import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { InjectModel, InjectConnection } from '@nestjs/mongoose';
import { Model, Types, Connection, ClientSession } from 'mongoose';
import * as bcrypt from 'bcrypt';
import dayjs from 'dayjs';
import utc from 'dayjs/plugin/utc';
dayjs.extend(utc);

import { PaystackService } from '../service/paystack.service';
import { User, UserDocument } from 'src/modules/user/schemas/user.schema';
import { Agent, AgentDocument } from 'src/modules/agent/schemas/agent.schema';
import { PaymentEscrow, PaymentEscrowDocument } from '../schema/payment-escrow.schema';
import { PaymentTransaction, PaymentTransactionDocument } from '../schema/payment-transaction.schema';
import { Booking, BookingDocument } from 'src/modules/booking/schemas/booking.schema';
import {
  AdminEscrowStatus,
  APPLICATION_FEE_PERCENTAGE,
  BookingStatus,
  EscrowStatus,
  EscrowType,
  KycStatus,
  PaymentStatus,
  PayoutType,
  Roles,
  TransactionPaymentStatus,
  TransactionType,
  ESCROW_RELEASE_DELAY_HOURS,
} from 'src/common/constants/enum';
import {
  FilterEscrowDto,
  FilterTransactionsDto,
  RequestWithdrawalDto,
  ResolveBankAccountDto,
  UpdateAdminEscrowStatusDto,
} from '../dto/payments.dto';
import { paginate } from 'src/common/utils/pagination.utils';
import { generateTransactionReference } from 'src/common/utils/generate-transaction-ref.utils';
import { NotificationEvents } from 'src/modules/notification/event/notification.event';

@Injectable()
export class PaymentsService {
  constructor(
    private readonly paystackService: PaystackService,
    @InjectModel(PaymentTransaction.name) private readonly txModel: Model<PaymentTransactionDocument>,
    @InjectModel(PaymentEscrow.name) private readonly escrowModel: Model<PaymentEscrowDocument>,
    @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
    @InjectModel(Agent.name) private readonly agentModel: Model<AgentDocument>,
    @InjectModel(Booking.name) private readonly bookingModel: Model<BookingDocument>,
    @InjectConnection() private readonly connection: Connection,
    private readonly notificationEvents: NotificationEvents,
  ) { }

  // ----------------------------
  // FUND WALLET
  // ----------------------------
  async fundWallet(userId: string, amount: number) {
    if (amount <= 0) throw new BadRequestException('Invalid amount');

    const user = await this.userModel.findById(userId).select('+customerCode');
    if (!user) throw new NotFoundException('User not found');

    let customerCode = user.customerCode;
    if (!customerCode) {
      const customer = await this.paystackService.createCustomer({
        first_name: user.firstname,
        last_name: user.lastname,
        email: user.email,
        phone: user.phoneNumber,
      });

      if (!customer?.customer_code)
        throw new BadRequestException('Failed to create Paystack customer');

      customerCode = customer.customer_code;
      user.customerCode = customerCode;
      await user.save();
    }

    const transaction = await this.paystackService.initializeTransaction({
      email: user.email,
      amount: amount * 100,
      customer: customerCode,
    });

    const exists = await this.txModel.findOne({ reference: transaction.reference });
    if (!exists) {
      await this.txModel.create({
        reference: transaction.reference,
        amount,
        type: TransactionType.CREDIT,
        status: TransactionPaymentStatus.PENDING,
        userId: new Types.ObjectId(userId),
        description: 'Wallet Top-up',
      });
    }

    return transaction;
  }

  // ----------------------------
  // VERIFY PAYMENT
  // ----------------------------
  async verifyPayment(reference: string) {
    const result = await this.paystackService.verifyTransaction(reference);

    if (!result.status || result.data.status !== 'success')
      throw new BadRequestException('Payment verification failed');

    const tx = await this.txModel.findOne({ reference });
    if (!tx) throw new BadRequestException('Transaction not found');

    if (tx.status === TransactionPaymentStatus.PENDING) {
      const session = await this.connection.startSession();
      try {
        await session.withTransaction(async () => {
          tx.status = TransactionPaymentStatus.SUCCESSFUL;
          await tx.save({ session });

          await this.userModel.updateOne(
            { _id: tx.userId },
            { $inc: { balance: tx.amount } },
            { session },
          );
        });
      } finally {
        await session.endSession();
      }
    }

    return result.data;
  }

  // ----------------------------
  // CREATE ESCROW AFTER BOOKING PAYMENT
  // ----------------------------
  async createEscrowAfterBookingPayment(
    bookingId: string,
    amount: number,
    agentId: string,
    txId?: string
  ) {
    const session = await this.connection.startSession();
    try {
      await session.withTransaction(async () => {
        const booking = await this.bookingModel.findById(bookingId).session(session);
        if (!booking) throw new NotFoundException('Booking not found');

        const agent = await this.agentModel.findById(agentId).session(session);
        if (!agent) throw new NotFoundException('Agent not found');

        const admin = await this.userModel.findOne({ role: Roles.ADMIN }).session(session);
        if (!admin) throw new NotFoundException('Admin not found');

        const feePercentage = APPLICATION_FEE_PERCENTAGE;
        const adminFee = Number((amount * feePercentage).toFixed(2));
        const escrowAmount = Number((amount - adminFee).toFixed(2));

        await this.userModel.updateOne(
          { _id: admin._id },
          { $inc: { balance: adminFee } },
          { session }
        );

        await this.escrowModel.create(
          [
            {
              bookingId: booking._id,
              userId: agent.userId,
              totalAmount: escrowAmount,
              amountReleased: 0,
              lastReleasedDay: 0,
              status: EscrowStatus.HOLD,
              payoutType: PayoutType.DAILY,
              adminEscrowStatus: AdminEscrowStatus.RELEASED,
              transactionId: txId ? new Types.ObjectId(txId) : undefined,
            },
          ],
          { session }
        );

        booking.paymentStatus = PaymentStatus.PAID;
        await booking.save({ session });
      });
    } finally {
      await session.endSession();
    }
  }

  async createWholeOrCautionEscrow(
    bookingId: string,
    userId: string,
    amount: number,
    txId?: string,
    releaseDate?: Date,
    isCautionFee = false
  ) {
    const session = await this.connection.startSession();
    try {
      await session.withTransaction(async () => {
        const booking = await this.bookingModel.findById(bookingId).session(session);
        if (!booking) throw new NotFoundException('Booking not found');

        await this.escrowModel.create([{
          bookingId: booking._id,
          userId: new Types.ObjectId(userId),
          totalAmount: amount,
          amountReleased: 0,
          lastReleasedDay: 0,
          status: EscrowStatus.HOLD,
          payoutType: PayoutType.WHOLE,
          adminEscrowStatus: AdminEscrowStatus.RELEASED,
          transactionId: txId ? new Types.ObjectId(txId) : undefined,
          releaseDate: releaseDate ?? dayjs(booking.endDate).add(ESCROW_RELEASE_DELAY_HOURS, 'hour').toDate(),
          referenceType: isCautionFee ? EscrowType.CAUTION_FEE : undefined,
        }], { session });

        booking.paymentStatus = PaymentStatus.PAID;
        await booking.save({ session });
      });
    } finally {
      await session.endSession();
    }
  }

  async refundBooking(
    bookingId: string,
    dto: { reason: string; status: BookingStatus; amount?: number; cautionFeeRefund?: number },
    externalSession?: ClientSession
  ) {
    if (externalSession) {
      return this.processRefund(bookingId, dto, externalSession);
    }

    const session = await this.connection.startSession();
    try {
      let result;
      await session.withTransaction(async () => {
        result = await this.processRefund(bookingId, dto, session);
      });
      return result;
    } finally {
      await session.endSession();
    }
  }

  private async processRefund(
    bookingId: string,
    dto: { reason: string; status: BookingStatus; amount?: number; cautionFeeRefund?: number },
    session: ClientSession
  ) {
    const { reason, status, amount, cautionFeeRefund } = dto;
    const booking = await this.bookingModel.findById(bookingId).session(session);
    if (!booking) throw new NotFoundException('Booking not found');

    // Use provided amount, or fallback to full refund calculation
    const amountToRefund = amount !== undefined ? amount : (booking.totalPrice + (booking.cautionFee ?? 0));
    const actualCautionRefund = cautionFeeRefund !== undefined ? cautionFeeRefund : (booking.cautionFee ?? 0);
    const bookingRefundAmount = Math.max(0, amountToRefund - actualCautionRefund);

    if (amountToRefund > 0) {
      await this.userModel.updateOne(
        { _id: booking.userId },
        { $inc: { balance: +amountToRefund } },
        { session },
      );

      await this.txModel.create(
        [
          {
            userId: booking.userId,
            amount: amountToRefund,
            type: TransactionType.CREDIT,
            status: TransactionPaymentStatus.REFUNDED,
            reference: `refund-${generateTransactionReference()}`,
            description: `Booking Refund`,
            metadata: { bookingId: booking._id, reason },
          },
        ],
        { session },
      );
    }

    // Fix: Unconditionally cancelling escrows caused agents to lose earnings on partial refunds
    const escrows = await this.escrowModel.find({ bookingId: booking._id }).session(session);

    for (const escrow of escrows) {
      if (escrow.referenceType === EscrowType.CAUTION_FEE) {
        // Fetch agent ONLY if we need to credit caution fee (and prevent crash if no escrows/agent not needed)
        const agent = await this.agentModel.findById(booking.agentId).session(session);
        if (!agent) throw new NotFoundException('Agent not found');

        // Calculate how much caution fee is KEPT by the agent/owner
        // If cautionFeeRefund < escrow.totalAmount, the difference is kept
        const keptCaution = Math.max(0, escrow.totalAmount - actualCautionRefund);
        const alreadyReleased = escrow.amountReleased || 0;
        // If we are keeping more than what was already released, credit the difference
        const amountToCreditOwner = Math.max(0, keptCaution - alreadyReleased);

        if (amountToCreditOwner > 0) {
          // Credit the AGENT/OWNER, not the customer (escrow.userId is customer for caution fee)
          await this.userModel.updateOne(
            { _id: agent.userId },
            { $inc: { balance: amountToCreditOwner } },
            { session }
          );
        }

        await this.escrowModel.updateOne(
          { _id: escrow._id },
          {
            $set: {
              status: EscrowStatus.COMPLETED,
              adminEscrowStatus: AdminEscrowStatus.RELEASED,
              amountReleased: (alreadyReleased + amountToCreditOwner),
              // totalAmount remains the same (it was the initial caution fee)
            },
          },
          { session }
        );
      } else {
        // Booking Fee Escrow
        // Calculate how much should be kept by the platform/agent
        // The kept amount is based on the BOOKING price, not total refund including caution fee
        const keptAmount = Math.max(0, booking.totalPrice - bookingRefundAmount);

        let agentShare = 0;
        let adminFee = 0;

        if (keptAmount > 0) {
          const feePercentage = APPLICATION_FEE_PERCENTAGE;
          adminFee = Number((keptAmount * feePercentage).toFixed(2));
          agentShare = Number((keptAmount - adminFee).toFixed(2));
        }

        // --- ADMIN FEE HANDLING FIX ---
        const admin = await this.userModel.findOne({ role: Roles.ADMIN }).session(session);
        if (admin) {
          if (escrow.payoutType === PayoutType.DAILY) {
            // APARTMENTS: Admin already collected 6% on the FULL booking price upfront.
            // On partial/full refund, they should only keep 6% of the keptAmount.
            // We must CLAW BACK the difference from the admin's balance.
            const originalAdminFee = Number((booking.totalPrice * APPLICATION_FEE_PERCENTAGE).toFixed(2));
            const adminRefundAmount = Math.max(0, originalAdminFee - adminFee);

            if (adminRefundAmount > 0) {
              await this.userModel.updateOne(
                { _id: admin._id },
                { $inc: { balance: -adminRefundAmount } },
                { session }
              );
            }
          } else if (escrow.payoutType === PayoutType.WHOLE) {
            // RIDES: Admin NEVER collected the 6% upfront.
            // We just calculated adminFee = keptAmount * 6%.
            // We MUST explicitly credit this fee to the admin now.
            if (adminFee > 0) {
              await this.userModel.updateOne(
                { _id: admin._id },
                { $inc: { balance: adminFee } },
                { session }
              );
            }
          }
        }
        // ------------------------------

        const alreadyReleased = escrow.amountReleased || 0;
        const amountToCreditAgent = Math.max(0, agentShare - alreadyReleased);
        const amountToClawback = Math.max(0, alreadyReleased - agentShare);

        if (amountToCreditAgent > 0) {
          await this.userModel.updateOne(
            { _id: escrow.userId },
            { $inc: { balance: amountToCreditAgent } },
            { session }
          );
        } else if (amountToClawback > 0) {
          await this.userModel.updateOne(
            { _id: escrow.userId },
            { $inc: { balance: -amountToClawback } },
            { session }
          );
        }

        await this.escrowModel.updateOne(
          { _id: escrow._id },
          {
            $set: {
              status: EscrowStatus.COMPLETED,
              adminEscrowStatus: AdminEscrowStatus.RELEASED,
              amountReleased: agentShare,
              totalAmount: agentShare // Update total amount to reflect the reduced final amount
            },
          },
          { session }
        );
      }
    }

    booking.status = status;
    booking.paymentStatus = PaymentStatus.REFUNDED;
    await booking.save({ session });

    return true;
  }

  // ----------------------------
  // DAILY ESCROW RELEASES
  // ----------------------------
  async processDailyDisbursements() {
    const escrows = await this.escrowModel.find({
      status: { $in: [EscrowStatus.HOLD, EscrowStatus.PARTIAL] },
      adminEscrowStatus: AdminEscrowStatus.RELEASED,
      payoutType: PayoutType.DAILY
    });
    await Promise.all(escrows.map((escrow) => this.releaseEscrow(escrow._id.toString())));
  }

  // ----------------------------
  // RELEASE ESCROW (DAILY)
  // ----------------------------
  async releaseEscrow(escrowId: string) {
    const session = await this.connection.startSession();
    try {
      await session.withTransaction(async () => {
        const escrow = await this.escrowModel.findOne({ _id: new Types.ObjectId(escrowId), payoutType: PayoutType.DAILY }).session(session);
        if (!escrow) throw new NotFoundException('Daily escrow not found');

        const booking = await this.bookingModel.findById(escrow.bookingId).session(session);
        if (!booking) throw new NotFoundException('Booking not found');

        const user = await this.userModel.findById(escrow.userId).session(session);
        if (!user) throw new NotFoundException('Agent not found');

        const totalAmount = escrow.totalAmount;
        const amountReleased = escrow.amountReleased ?? 0;
        const lastReleasedDay = escrow.lastReleasedDay ?? 0;

        const start = dayjs.utc(booking.startDate).startOf('day');
        const end = dayjs.utc(booking.endDate).startOf('day');
        const totalDays = Math.max(1, Math.ceil(end.diff(start, 'day')));
        const now = dayjs.utc().startOf('day');

        if (now.isBefore(dayjs.utc(booking.startDate).add(ESCROW_RELEASE_DELAY_HOURS, 'hour'))) return;

        const daysElapsed = Math.min(totalDays, Math.max(0, now.diff(start, 'day') + 1));
        if (daysElapsed <= lastReleasedDay) return;

        const daysDue = daysElapsed - lastReleasedDay;
        const perDay = Math.floor((totalAmount / totalDays) * 100) / 100;

        const remainingDays = totalDays - lastReleasedDay;
        const amountToRelease =
          daysDue >= remainingDays
            ? Number((totalAmount - amountReleased).toFixed(2))
            : Number((perDay * daysDue).toFixed(2));

        if (amountToRelease <= 0) return;

        const newAmountReleased = Number((amountReleased + amountToRelease).toFixed(2));
        const newLastReleasedDay = lastReleasedDay + daysDue;

        const escrowStatus =
          newAmountReleased >= totalAmount || newLastReleasedDay >= totalDays
            ? EscrowStatus.COMPLETED
            : EscrowStatus.PARTIAL;

        await this.escrowModel.updateOne(
          { _id: escrow._id },
          {
            amountReleased: newAmountReleased,
            lastReleasedDay: newLastReleasedDay,
            status: escrowStatus,
          },
          { session },
        );

        const txStatus =
          escrowStatus === EscrowStatus.COMPLETED
            ? TransactionPaymentStatus.SUCCESSFUL
            : TransactionPaymentStatus.PROCESSING;

        await this.txModel.updateOne(
          { _id: new Types.ObjectId(escrow.transactionId) },
          {
            $set: {
              status: txStatus,
              amount: newAmountReleased,
              metadata: { escrowId: escrow._id, daysDue },
            },
          },
          { session },
        );

        await this.userModel.updateOne(
          { _id: user._id },
          { $inc: { balance: amountToRelease } },
          { session },
        );

        if (escrowStatus === EscrowStatus.COMPLETED) {
          await this.bookingModel.updateOne(
            { _id: booking._id },
            { status: BookingStatus.COMPLETED },
            { session },
          );
        }
      });
    } finally {
      await session.endSession();
    }
  }

  async processWholeEscrowReleases() {
    const now = dayjs.utc();

    const dueEscrows = await this.escrowModel.find({
      payoutType: PayoutType.WHOLE,
      adminEscrowStatus: {
        $in: [AdminEscrowStatus.RELEASED, AdminEscrowStatus.AGENT_HOLD],
      },
      status: EscrowStatus.HOLD,
      releaseDate: { $lte: now.toDate() },
    });

    await Promise.all(
      dueEscrows.map(async (escrow) => {
        const session = await this.connection.startSession();

        let recipientId: string | null = null;
        let notificationPayload: {
          title: string;
          body: string;
          extras?: any;
        } | null = null;

        try {
          await session.withTransaction(async () => {
            const escrowDoc = await this.escrowModel
              .findOne({ _id: escrow._id, status: EscrowStatus.HOLD })
              .session(session);

            if (!escrowDoc) {
              return;
            }

            const booking = await this.bookingModel
              .findById(escrowDoc.bookingId)
              .session(session);

            if (!booking) throw new Error('Booking not found');

            const userId = booking.userId;
            const agentDoc = await this.agentModel.findById(booking.agentId).session(session);
            if (!agentDoc) throw new Error('Agent not found');
            const agentUserId = agentDoc.userId;

            let walletOwner: Types.ObjectId;
            let notificationTitle: string;
            let notificationBody: string;
            let txDescription: string;

            if (escrowDoc.referenceType === EscrowType.CAUTION_FEE) {
              if (escrowDoc.adminEscrowStatus === AdminEscrowStatus.AGENT_HOLD) {
                walletOwner = agentUserId;
                notificationTitle = 'Caution Fee Released';
                notificationBody = `Caution fee of ₦${escrowDoc.totalAmount} has been released to your wallet.`;
                txDescription = 'Caution Fee Payout';
              } else {
                walletOwner = userId;
                notificationTitle = 'Caution Fee Refunded';
                notificationBody = `Your caution fee of ₦${escrowDoc.totalAmount} has been refunded to your wallet.`;
                txDescription = 'Caution Fee Refund';
              }
            } else {
              walletOwner = agentUserId;
              notificationTitle = 'Booking Payment Released';
              notificationBody = `Your booking payment of ₦${escrowDoc.totalAmount} has been released to your wallet.`;
              txDescription = 'Booking Revenue';
            }
            await this.userModel.updateOne(
              { _id: walletOwner },
              { $inc: { balance: escrowDoc.totalAmount } },
              { session }
            );

            /** =============================
             *  TRANSACTIONS
             ============================== */
            if (escrowDoc.referenceType === EscrowType.CAUTION_FEE) {
              await this.txModel.create(
                [
                  {
                    reference: `TX-${generateTransactionReference()}`,
                    userId: walletOwner,
                    bookingId: escrowDoc.bookingId,
                    amount: escrowDoc.totalAmount,
                    type: TransactionType.CREDIT,
                    status: TransactionPaymentStatus.SUCCESSFUL,
                    description: txDescription,
                    metadata: { escrowId: escrowDoc._id.toString() },
                  },
                ],
                { session }
              );
            } else {
              await this.txModel.updateOne(
                { _id: new Types.ObjectId(escrowDoc.transactionId) },
                { $set: { status: TransactionPaymentStatus.SUCCESSFUL } },
                { session }
              );
            }

            /** =============================
             *  FINAL STATUS UPDATES
             ============================== */
            await this.escrowModel.updateOne(
              { _id: escrowDoc._id },
              { $set: { status: EscrowStatus.COMPLETED } },
              { session }
            );

            await this.bookingModel.updateOne(
              { _id: booking._id },
              { $set: { status: BookingStatus.COMPLETED } },
              { session }
            );

            recipientId = walletOwner.toString();
            notificationPayload = {
              title: notificationTitle,
              body: notificationBody,
              extras: {
                escrowId: escrowDoc._id.toString(),
                bookingId: escrowDoc.bookingId.toString(),
              },
            };
          });
        } catch (err) {
          console.error(`Failed to process escrow ${escrow._id.toString()}:`, err);
        } finally {
          await session.endSession();
        }

        /** =============================
         *  SEND NOTIFICATION (OUTSIDE TX)
         ============================== */
        if (recipientId && notificationPayload) {
          try {
            const recipient = await this.userModel
              .findById(recipientId)
              .select('deviceToken notificationsEnabled');

            if (recipient?.notificationsEnabled && recipient?.deviceToken) {
              this.notificationEvents.emitNotification({
                token: recipient.deviceToken,
                title: notificationPayload.title,
                body: notificationPayload.body,
                extras: notificationPayload.extras,
              });
            }
          } catch (err) {
            console.error(
              `Failed to send notification for escrow ${escrow._id.toString()} to ${recipientId}:`,
              err
            );
          }
        }
      })
    );
  }



  // ----------------------------
  // GET ALL ESCROWS (PAGINATED)
  // ----------------------------
  async getAllEscrows(query: FilterEscrowDto) {
    const filter: any = {};

    if (query.status) filter.status = query.status;
    if (query.payoutType) filter.payoutType = query.payoutType;
    if (query.adminEscrowStatus) filter.adminEscrowStatus = query.adminEscrowStatus;
    if (query.searchTerm) {
      filter.$or = [
        { reference: { $regex: query.searchTerm, $options: 'i' } },
        { description: { $regex: query.searchTerm, $options: 'i' } },
      ];
    }

    return paginate({
      model: this.escrowModel,
      filter,
      params: query,
      sort: { createdAt: -1 }
    });
  }

  // ----------------------------
  // ADMIN UPDATE ESCROW
  // ----------------------------
  async updateEscrowStatus(escrowId: string, dto: UpdateAdminEscrowStatusDto) {
    const updatedEscrow = await this.escrowModel.findByIdAndUpdate(
      escrowId,
      { $set: { adminEscrowStatus: dto.status } },
      { new: true },
    );

    if (!updatedEscrow) throw new NotFoundException('Escrow not found');

    return updatedEscrow;
  }


  // ----------------------------
  // WITHDRAWAL
  // ----------------------------
  async requestWithdrawal(userId: string, dto: RequestWithdrawalDto) {
    const { amount, password } = dto;
    if (amount <= 0) throw new BadRequestException('Invalid withdrawal amount');

    const user = await this.userModel.findById(userId).select('+passwordHash');
    if (!user) throw new BadRequestException('User not found');
    if (user.kycStatus !== KycStatus.VERIFIED)
      throw new BadRequestException('Verify your account before withdrawing');

    const valid = await bcrypt.compare(password, user.passwordHash);
    if (!valid) throw new BadRequestException('Invalid password');

    const recipient = await this.paystackService.createTransferRecipient({
      type: 'nuban',
      name: dto.fullName,
      account_number: dto.accountNumber,
      bank_code: dto.bankCode,
    });
    if (!recipient?.recipient_code) throw new BadRequestException('Failed to create recipient');

    const session = await this.connection.startSession();
    try {
      let tx;
      await session.withTransaction(async () => {
        const updated = await this.userModel.findOneAndUpdate(
          { _id: user._id, balance: { $gte: amount } },
          { $inc: { balance: -amount } },
          { new: true, session },
        );
        if (!updated) throw new BadRequestException('Insufficient balance');

        const reason = 'Withdrawal to Bank Account';
        const transfer = await this.paystackService.initiateTransfer({
          recipient: recipient.recipient_code,
          amount: amount * 100,
          reason,
          source: 'balance',
        });

        tx = await this.txModel.create(
          [
            {
              reference: transfer.transfer_code,
              amount,
              type: TransactionType.DEBIT,
              status: TransactionPaymentStatus.SUCCESSFUL,
              userId: new Types.ObjectId(userId),
              description: reason,
            },
          ],
          { session },
        );
      });
      return tx;
    } finally {
      await session.endSession();
    }
  }

  // ----------------------------
  // TRANSACTIONS
  // ----------------------------
  async getAllTransactions(query: FilterTransactionsDto, userId?: string) {
    const filter: any = userId ? { userId: new Types.ObjectId(userId) } : {};

    if (query.status) filter.status = query.status;
    if (query.type) filter.type = query.type;
    if (query.searchTerm) {
      filter.$or = [
        { reference: { $regex: query.searchTerm, $options: 'i' } },
        { description: { $regex: query.searchTerm, $options: 'i' } },
      ];
    }

    return paginate({
      model: this.txModel,
      filter,
      params: query,
      sort: { createdAt: -1 },
    });
  }

  async getTransactionById(transactionId: string) {
    const tx = await this.txModel.findById(transactionId);
    if (!tx) throw new NotFoundException('Transaction not found');
    return tx;
  }

  async getBanks() {
    return this.paystackService.getBankList();
  }

  async resolveBankAccount(dto: ResolveBankAccountDto) {
    return this.paystackService.resolveAccount(dto);
  }

  async getEscrowReleasedAmount(bookingId: string, session?: ClientSession): Promise<number> {
    const escrows = await this.escrowModel.find({ bookingId: new Types.ObjectId(bookingId) }).session(session);
    return escrows.reduce((sum, escrow) => sum + (escrow.amountReleased || 0), 0);
  }
}
