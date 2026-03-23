import { Injectable, BadRequestException, Logger, UnauthorizedException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { PaymentTransaction, PaymentTransactionDocument } from '../schema/payment-transaction.schema';
import { User, UserDocument } from 'src/modules/user/schemas/user.schema';
import * as crypto from 'crypto';
import { Request } from 'express';
import { ConfigService } from '@nestjs/config';
import { TransactionPaymentStatus } from 'src/common/constants/enum';

@Injectable()
export class PaystackWebhookService {
  private readonly logger = new Logger(PaystackWebhookService.name);

  constructor(
    @InjectModel(PaymentTransaction.name) private txModel: Model<PaymentTransactionDocument>,
    @InjectModel(User.name) private userModel: Model<UserDocument>,
    private readonly config: ConfigService
  ) { }

  validateWebhookEvent(req: Request): void {
    const signature = req.headers['x-paystack-signature'] as string;
    if (!signature) throw new UnauthorizedException('Missing Paystack signature');

    const hash = crypto
      .createHmac('sha512', this.config.get<string>('paystack.secretKey'))
      .update(JSON.stringify(req.body))
      .digest('hex');

    if (hash !== signature) {
      throw new UnauthorizedException('Invalid Paystack signature');
    }
  }
  async handleTransferReversed(data: any) {
    const tx = await this.txModel.findOne({ reference: data.transfer_code });
    if (!tx) throw new BadRequestException('Transaction not found');

    tx.status = TransactionPaymentStatus.REVERSED;
    await tx.save();

    if (tx.userId) {
      await this.userModel.updateOne(
        { _id: tx.userId },
        { $inc: { balance: tx.amount } }
      );
    }

    this.logger.warn(`Transfer reversed: ref=${data.transfer_code} amount=${tx.amount} user=${tx.userId?.toString()}`);
    return { message: 'Transfer reversed and balance refunded' };
  }


  async handleChargeSuccess(data: any) {
    const tx = await this.txModel.findOne({ reference: data.reference });
    if (!tx) throw new BadRequestException('Transaction not found');

    if (tx.status === TransactionPaymentStatus.PENDING) {
      tx.status = TransactionPaymentStatus.SUCCESSFUL;
      await tx.save();

      await this.userModel.updateOne(
        { _id: tx.userId },
        { $inc: { balance: tx.amount } }
      );

      this.logger.log(`Charge successful: ref=${data.reference} amount=${tx.amount} user=${tx.userId?.toString()}`);
    }

    return { message: 'Wallet funded successfully via webhook' };
  }

  async handleTransferSuccess(data: any) {
    const tx = await this.txModel.findOne({ reference: data.transfer_code });
    if (!tx) throw new BadRequestException('Transaction not found');

    if (tx.status === TransactionPaymentStatus.PENDING) {
      tx.status = TransactionPaymentStatus.SUCCESSFUL;
      await tx.save();
      this.logger.log(`Transfer successful: ref=${data.transfer_code} amount=${tx.amount} user=${tx.userId?.toString()}`);
    }

    return { message: 'Withdrawal successful via webhook' };
  }

  async handleTransferFailed(data: any) {
    const tx = await this.txModel.findOne({ reference: data.transfer_code });
    if (!tx) throw new BadRequestException('Transaction not found');

    if (tx.status === TransactionPaymentStatus.PENDING) {
      tx.status = TransactionPaymentStatus.FAILED;
      await tx.save();
      if (tx.userId) {
        await this.userModel.updateOne(
          { _id: tx.userId },
          { $inc: { balance: tx.amount } }
        );
      }
      this.logger.warn(`Transfer failed: ref=${data.transfer_code} amount=${tx.amount} user=${tx.userId?.toString()} — balance refunded`);
    }

    return { message: 'Withdrawal failed and refunded' };
  }
  // validateWehbookEvent(req: Request): void {
  //   const paystackSignature = req.headers['x-paystack-signature'] as string;
  //   if (!paystackSignature) {
  //     throw new UnauthorizedException('Missing Paystack signature');
  //   }

  //   const hash = crypto
  //     .createHmac('sha512', this.config.get<string>('paystack.secretKey'))
  //     .update(JSON.stringify(req.body))
  //     .digest('hex');

  //   if (hash !== paystackSignature) {
  //     throw new UnauthorizedException('Invalid Paystack signature');
  //   }
  // }

}
