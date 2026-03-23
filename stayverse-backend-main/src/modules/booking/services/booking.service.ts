import {
  BadRequestException,
  Injectable,
  Logger,
  NotFoundException,
  UnauthorizedException,
} from '@nestjs/common';
import { InjectConnection, InjectModel } from '@nestjs/mongoose';
import { Booking, BookingDocument } from '../schemas/booking.schema';
import { Connection, Model, Types } from 'mongoose';
import { BookingStatusDto, CreateBookingDto, UpdateBookingDto } from '../dto/booking.dto';
import {
  BookedStatus,
  BookingStatus,
  CAUTION_FEE,
  EscrowStatus,
  PaymentStatus,
  ServiceType,
  TransactionPaymentStatus,
  TransactionType,
  RIDE_CANCELLATION_FEE_PERCENTAGE,
} from 'src/common/constants/enum';
import { Apartment, ApartmentDocument } from 'src/modules/apartment/schemas/apartment.schema';
import { Agent, AgentDocument } from 'src/modules/agent/schemas/agent.schema';
import { Ride, RideDocument } from 'src/modules/rides/schemas/rides.schema';
import { GetAdminBookingsDto } from '../dto/get-admin-bookings.dto';
import { toObjectId } from 'src/common/utils/objectId.utils';
import dayjs from 'dayjs';
import isSameOrBefore from 'dayjs/plugin/isSameOrBefore'
import utc from 'dayjs/plugin/utc';
import { paginate, PaginateOptions } from 'src/common/utils/pagination.utils';
import { User, UserDocument } from 'src/modules/user/schemas/user.schema';
import { PaymentTransaction, PaymentTransactionDocument } from 'src/modules/payments/schema/payment-transaction.schema';
import { PaymentsService } from 'src/modules/payments/service/payments.service';
import { generateTransactionReference } from 'src/common/utils/generate-transaction-ref.utils';
import { NotificationEvents } from 'src/modules/notification/event/notification.event';
import { PaginationQueryDto } from 'src/common/dtos/pagination-query.dto';
import { GoogleMapsService } from 'src/common/providers/google-map.service';
dayjs.extend(utc);
dayjs.extend(isSameOrBefore);

@Injectable()
export class BookingService {
  private readonly logger = new Logger(BookingService.name);

  constructor(
    @InjectModel(Booking.name) private readonly bookingModel: Model<BookingDocument>,
    @InjectModel(Apartment.name) private readonly apartmentModel: Model<ApartmentDocument>,
    @InjectModel(Ride.name) private readonly rideModel: Model<RideDocument>,
    @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
    @InjectModel(PaymentTransaction.name) private readonly txModel: Model<PaymentTransactionDocument>,
    @InjectConnection() private readonly connection: Connection,
    private readonly paymentsService: PaymentsService,
    private readonly notificationEvents: NotificationEvents,

    private readonly googleMapsService: GoogleMapsService,
    @InjectModel(Agent.name) private readonly agentModel: Model<AgentDocument>,
  ) { }

  private async findService(serviceType: ServiceType, dto: CreateBookingDto): Promise<any> {
    if (serviceType === ServiceType.APARTMENT && dto.apartmentId) {
      const apartment = await this.apartmentModel.findById(dto.apartmentId).populate('agent');
      if (!apartment) throw new NotFoundException('Apartment not found');
      return apartment;
    }

    if (serviceType === ServiceType.RIDE && dto.rideId) {
      const ride = await this.rideModel.findById(dto.rideId).populate('agent');
      if (!ride) throw new NotFoundException('Ride not found');
      return ride;
    }

    throw new BadRequestException('Invalid service ID for selected type');
  }

  private async checkAvailability(serviceType: ServiceType, dto: CreateBookingDto) {
    const now = new Date();

    const startDate = new Date(dto.startDate);

    startDate.setSeconds(0, 0);

    // if (startDate < now) {
    //   throw new BadRequestException('Start date cannot be in the past');
    // }

    let endDate: Date;

    if (serviceType === ServiceType.APARTMENT) {
      if (!dto.endDate) throw new BadRequestException('End date is required for apartment bookings');

      endDate = new Date(dto.endDate);
      endDate.setSeconds(0, 0);

      if (endDate <= startDate) {
        throw new BadRequestException('End date must be after start date');
      }
    }

    if (serviceType === ServiceType.RIDE) {
      if (!dto.totalHours) {
        throw new BadRequestException('Total hours is required for ride bookings');
      }
      endDate = new Date(startDate.getTime() + dto.totalHours * 60 * 60 * 1000);
    }

    const match: any = {
      status: BookingStatus.ACCEPTED,
      startDate: { $lt: endDate },
      endDate: { $gt: startDate },
    };

    if (serviceType === ServiceType.APARTMENT) match.apartmentId = dto.apartmentId;
    if (serviceType === ServiceType.RIDE) match.rideId = dto.rideId;

    const existingBooking = await this.bookingModel.findOne(match);

    if (existingBooking) {
      throw new BadRequestException(`${serviceType} already booked during this period`);
    }
  }

  private calculateTotalPrice(
    serviceType: ServiceType,
    start: Date,
    end: Date,
    service: any,
  ): number {

    const durationMs = end.getTime() - start.getTime();

    if (serviceType === ServiceType.RIDE) {
      const hours = durationMs / (1000 * 60 * 60);
      return hours * service.pricePerHour;
    }

    const days = Math.ceil(durationMs / (1000 * 60 * 60 * 24));
    return days * service.pricePerDay;
  }

  async createBooking(request: CreateBookingDto, userId: string) {
    const user = await this.userModel.findById(userId).select('+balance');
    if (!user) throw new NotFoundException('User not found');

    const dto = { ...request };
    let pickupAddress;

    switch (dto.serviceType) {
      case ServiceType.APARTMENT:
        dto.rideId = null;
        if (dto.apartmentId) dto.apartmentId = new Types.ObjectId(dto.apartmentId);
        break;

      case ServiceType.RIDE: {
        dto.apartmentId = null;
        if (dto.rideId) dto.rideId = new Types.ObjectId(dto.rideId);

        if (!dto.totalHours || dto.totalHours < 1) {
          throw new BadRequestException('totalHours is required for ride service');
        }
        if (!dto.pickupPlaceId) {
          throw new BadRequestException('Pickup place is required for ride service');
        }
        const geo = await this.googleMapsService.reverseGeocode(dto?.pickupPlaceId);
        pickupAddress = geo.formattedAddress || 'Unknown address';
        const start = new Date(dto.startDate);
        const calculatedEnd = new Date(start);
        calculatedEnd.setHours(start.getHours() + dto.totalHours);

        dto.endDate = calculatedEnd;

        break;
      }
    }


    const service = await this.findService(dto.serviceType, dto);


    await this.checkAvailability(dto.serviceType, dto);


    const bookingPrice = this.calculateTotalPrice(
      dto.serviceType,
      dto.startDate,
      dto.endDate,
      service,
    );
    const cautionFee = service?.cautionFee ?? CAUTION_FEE;
    const totalPrice = bookingPrice + cautionFee;

    if (user.balance < totalPrice) throw new BadRequestException('Insufficient balance');
    const bookingPayload = {
      ...dto,
      userId: new Types.ObjectId(userId),
      totalPrice: bookingPrice,
      cautionFee,
      agentId: service.agentId,
      paymentStatus: PaymentStatus.PAID,
      escrowStatus: EscrowStatus.HOLD,
      pickupAddress,
    };

    const session = await this.connection.startSession();
    let booking;
    try {
      await session.withTransaction(async () => {
        booking = await this.bookingModel.create([bookingPayload], { session });

        await this.txModel.create([{
          reference: `TX-${generateTransactionReference()}`,
          amount: totalPrice,
          type: TransactionType.DEBIT,
          status: TransactionPaymentStatus.SUCCESSFUL,
          userId: new Types.ObjectId(userId),
          description: `Booking created by ${user.firstname} for ${dto.serviceType} service`,
        }], { session });

        user.balance -= totalPrice;
        await user.save({ session });
      });

      const agent = await this.userModel.findById(service.agent.userId).select('+deviceToken');

      if (agent?.notificationsEnabled && agent?.deviceToken) {
        this.notificationEvents.emitNotification({
          token: agent.deviceToken,
          title: 'New Booking',
          body: `${user.firstname} booked your ${dto.serviceType} service.`,
          extras: { bookingId: booking[0]._id.toString(), serviceType: dto.serviceType },
        });
      }

      this.logger.log(
        `Booking created: id=${booking[0]._id} user=${userId} type=${dto.serviceType} price=${bookingPrice} cautionFee=${cautionFee} total=${totalPrice}`,
      );

      return {
        message: 'Booking created and funds held in escrow',
        booking: booking[0],
      };
    } finally {
      await session.endSession();
    }
  }

  async updateBooking(id: string, dto: UpdateBookingDto, userId: string) {
    const booking = await this.bookingModel.findById(id);
    if (!booking) throw new NotFoundException('Booking not found');
    if (booking.userId.toString() !== userId) throw new BadRequestException('Not authorized');
    if (booking.status !== BookingStatus.PENDING) throw new BadRequestException('Only pending bookings can be updated');

    Object.assign(booking, dto);
    await booking.save();

    return { message: 'Booking updated successfully', booking };
  }

  async cancelBooking(bookingId: string, userId: string) {
    const session = await this.connection.startSession();
    try {
      return await session.withTransaction(async () => {
        const booking = await this.bookingModel
          .findById(bookingId)
          .populate<{ apartment: ApartmentDocument; ride: RideDocument; chef: any }>(
            'apartment ride chef'
          )
          .session(session);

        if (!booking) throw new NotFoundException('Booking not found');
        if (booking.userId.toString() !== userId)
          throw new UnauthorizedException('Not authorized to cancel this booking');

        if (
          [
            BookingStatus.COMPLETED,
            BookingStatus.CANCELLED,
            BookingStatus.REJECTED,
          ].includes(booking.status)
        ) {
          throw new BadRequestException('Cannot cancel a completed or already processed booking');
        }

        const now = dayjs();
        const startDate = dayjs(booking.startDate);
        const hoursDiff = startDate.diff(now, 'hour');
        const daysDiff = startDate.diff(now, 'day');

        let refundPercentage = 0;

        // 1. APARTMENT & CHEF LOGIC
        if (
          booking.serviceType === ServiceType.APARTMENT ||
          booking.serviceType === ServiceType.CHEF
        ) {
          if (booking.status === BookingStatus.PENDING) {
            refundPercentage = 1; // 100% refund if not accepted yet
          } else if (daysDiff >= 7) {
            refundPercentage = 1; // 100% refund
          } else if (daysDiff < 7 && hoursDiff >= 24) {
            refundPercentage = 0.5; // 50% refund
          } else {
            refundPercentage = 0; // 0% refund (< 24 hours)
          }
        }

        // 2. RIDE LOGIC
        else if (booking.serviceType === ServiceType.RIDE) {
          // If not yet accepted by agent/driver -> Full Refund
          if (booking.status === BookingStatus.PENDING) {
            refundPercentage = 1;
          } else {
            // If accepted -> Refund minus cancellation fee (20%)
            // Policy Assumption: Ride hasn't started yet.
            if (now.isAfter(startDate)) {
              // Started? No refund if already started
              refundPercentage = 0;
            } else {
              // Future ride (or just started but strict buffer)
              // 20% cancellation fee
              refundPercentage = 1 - RIDE_CANCELLATION_FEE_PERCENTAGE;
            }
          }
        }

        // Calculate Amounts
        const releasedAmount = await this.paymentsService.getEscrowReleasedAmount(booking._id.toString(), session);
        const maxRefundable = Math.max(0, booking.totalPrice - releasedAmount);

        const calculatedRefund = Number((booking.totalPrice * refundPercentage).toFixed(2));
        const bookingRefundAmount = Math.min(calculatedRefund, maxRefundable);

        // Apply refund percentage to caution fee as well
        // If 0% refund policy, caution fee is also 0% returned (confiscated)
        const cautionFee = booking.cautionFee ?? 0;
        const cautionFeeRefund = Number((cautionFee * refundPercentage).toFixed(2));

        const totalRefund = bookingRefundAmount + cautionFeeRefund;

        // Reset Service Status
        if (booking.serviceType === ServiceType.APARTMENT && booking.apartmentId) {
          await this.apartmentModel.findByIdAndUpdate(booking.apartmentId, { bookedStatus: BookedStatus.AVAILABLE }).session(session);
        } else if (booking.serviceType === ServiceType.RIDE && booking.rideId) {
          await this.rideModel.findByIdAndUpdate(booking.rideId, { bookedStatus: BookedStatus.AVAILABLE }).session(session);
        }

        // Process Refund if Paid
        if (booking.paymentStatus === PaymentStatus.PAID) {
          await this.paymentsService.refundBooking(booking._id.toString(), {
            reason: 'User requested cancellation',
            status: BookingStatus.CANCELLED,
            amount: totalRefund,
            cautionFeeRefund: cautionFeeRefund
          }, session);
        } else {
          // Update Status only if not handled by refundBooking
          booking.status = BookingStatus.CANCELLED;
          await booking.save({ session });
        }

        // Notify Agent
        if (booking.agentId) {
          const agentDoc = await this.agentModel.findById(booking.agentId).session(session);
          if (agentDoc) {
            const agentUser = await this.userModel.findById(agentDoc.userId).select('+deviceToken notificationsEnabled').session(session);
            if (agentUser?.notificationsEnabled && agentUser?.deviceToken) {
              this.notificationEvents.emitNotification({
                token: agentUser.deviceToken,
                title: 'Booking Cancelled',
                body: 'A user has cancelled their booking.',
                extras: { bookingId: booking._id.toString(), serviceType: booking.serviceType },
              });
            }
          }
        }

        this.logger.log(
          `Booking cancelled: id=${bookingId} user=${userId} type=${booking.serviceType} refund=${totalRefund} (booking=${bookingRefundAmount} + caution=${cautionFeeRefund})`,
        );

        return {
          message: 'Booking cancelled successfully',
          booking,
          refundAmount: totalRefund
        };
      });
    } finally {
      await session.endSession();
    }
  }

  async getUnavailableDates(serviceType: ServiceType, id: string): Promise<Date[]> {

    const filter: Record<string, any> = {
      status: BookingStatus.ACCEPTED
    };

    if (serviceType === ServiceType.APARTMENT) {
      filter.apartmentId = new Types.ObjectId(id);
    } else if (serviceType === ServiceType.RIDE) {
      filter.rideId = new Types.ObjectId(id);
    } else {
      throw new BadRequestException('Invalid service type');
    }

    const bookings = await this.bookingModel.find(filter);
    const unavailableDates = new Set<number>();

    for (const booking of bookings) {
      const dates = this.generateDateRange(booking.startDate, booking.endDate);
      dates.forEach(date => unavailableDates.add(date.getTime()));
    }

    return [...unavailableDates].map(timestamp => new Date(timestamp));
  }

  private generateDateRange(start: Date, end: Date): Date[] {
    const startDay = dayjs.utc(start).startOf('day');
    const endDay = dayjs.utc(end).startOf('day');
    const dates: Date[] = [];

    for (let d = startDay; d.isSameOrBefore(endDay); d = d.add(1, 'day')) {
      dates.push(d.toDate());
    }

    return dates;
  }

  async agentBookingUpdate(id: string, ownerId: string, bookingStatus: BookingStatus, response: string) {
    const booking = await this.bookingModel.findOne({ _id: new Types.ObjectId(id), status: BookingStatus.PENDING })
      .populate<{ user: UserDocument }>({
        path: 'user',
        select: 'firstname deviceToken notificationsEnabled',
      });

    if (!booking) throw new NotFoundException('Booking status has already been updated');

    let serviceModel, serviceId;

    if (booking.serviceType === ServiceType.APARTMENT) {
      serviceModel = this.apartmentModel;
      serviceId = booking.apartmentId;
    } else if (booking.serviceType === ServiceType.RIDE) {
      serviceModel = this.rideModel;
      serviceId = booking.rideId;
    }

    if (!serviceModel || !serviceId) throw new NotFoundException('Service not found');

    const service = await serviceModel.findById(serviceId);
    if (!service) throw new NotFoundException('Service not found');

    const owner = service.agentId?.toString() || service.ownerId?.toString();
    if (owner !== ownerId) throw new UnauthorizedException('Not authorized');

    booking.status = bookingStatus;
    if (bookingStatus === BookingStatus.ACCEPTED) {
      const txRef = `TX-${generateTransactionReference()}`;
      const cautionFee = CAUTION_FEE;

      await booking.save();

      if (booking.serviceType === ServiceType.APARTMENT) {
        const tx = await this.txModel.create({
          reference: txRef,
          amount: booking.totalPrice,
          type: TransactionType.CREDIT,
          status: TransactionPaymentStatus.PENDING,
          userId: new Types.ObjectId(ownerId),
          description: `Payout for ${booking.serviceType} service in escrow`,
        });

        await Promise.all([
          serviceModel.findByIdAndUpdate(
            serviceId,
            { bookedStatus: BookedStatus.BOOKED },
            { new: true, runValidators: true }
          ),
          this.paymentsService.createEscrowAfterBookingPayment(
            booking._id.toString(),
            booking.totalPrice,
            ownerId,
            tx._id.toString()
          ),
          this.paymentsService.createWholeOrCautionEscrow(
            booking._id.toString(),
            booking.userId.toString(),
            service.cautionFee || cautionFee,
            undefined,
            undefined,
            true
          ),
        ]);

      } else if (booking.serviceType === ServiceType.RIDE) {
        await Promise.all([
          serviceModel.findByIdAndUpdate(
            serviceId,
            { bookedStatus: BookedStatus.BOOKED },
            { new: true, runValidators: true }
          ),
          this.paymentsService.createWholeOrCautionEscrow(
            booking._id.toString(),
            ownerId,
            booking.totalPrice,
            txRef,
            booking.endDate,
            false
          ),
          this.paymentsService.createWholeOrCautionEscrow(
            booking._id.toString(),
            booking.userId.toString(),
            service.cautionFee || cautionFee,
            undefined,
            undefined,
            true
          ),
        ]);
      }
    }

    if (bookingStatus === BookingStatus.REJECTED) {
      await Promise.all([
        this.paymentsService.refundBooking(booking._id.toString(), {
          reason: 'Booking rejected by agent',
          status: BookingStatus.REJECTED,
        }),
        booking.save(),
      ]);
    }

    const user = booking.user;
    if (user?.notificationsEnabled && user?.deviceToken) {
      this.notificationEvents.emitNotification({
        token: user.deviceToken,
        title: `Booking ${bookingStatus.toLowerCase()}`,
        body: `Your booking for ${booking.serviceType} has been ${bookingStatus.toLowerCase()} by the agent.`,
        extras: { bookingId: booking._id.toString(), serviceType: booking.serviceType },
      });
    }

    this.logger.log(
      `Booking status updated: id=${id} status=${bookingStatus} by agent=${ownerId} type=${booking.serviceType}`,
    );

    return { message: response, booking };
  }

  async getUserBookings(userId: string, query: BookingStatusDto) {
    const filter = { userId: toObjectId(userId), status: query.status };
    return this.getBookings(filter, query);
  }
  async getBookingById(bookingId: string, query: PaginationQueryDto) {
    const filter = { _id: toObjectId(bookingId) };
    return this.getBookings(filter, query)
  }
  async getAgentBookings(agentId: string, query: BookingStatusDto) {
    const filter = { agentId: toObjectId(agentId), status: query.status }
    return this.getBookings(filter, query);
  }

  private async getBookings(filter: any, query: any) {
    const options: PaginateOptions<any> = {
      model: this.bookingModel,
      filter,
      params: query,
      sort: { createdAt: -1 },
      populate: [
        {
          path: 'user',
          select: '-passwordHash -__v -createdAt -updatedAt -socketId -role -otp -pinExpires',
        },
        {
          path: 'agent',
          select: '-__v -balance',
          populate: {
            path: 'user',
            model: 'User',
            select: '-_id -role -passwordHash -__v -createdAt -updatedAt',
          }
        },
        {
          path: 'apartment',
          select: '-__v',
        },
        {
          path: 'chef',
          select: '-__v',
          populate: [
            { path: 'certifications', select: '-__v' },
            { path: 'features', select: '-__v' },
            { path: 'experiences', select: '-__v' },
          ],
        },
        {
          path: 'ride',
          select: '-__v',
        }
      ]
    };

    return paginate(options);
  }
  async getAdminBookings(query: GetAdminBookingsDto) {
    const filter: any = {};

    if (query.agentId) filter.agentId = query.agentId;
    if (query.serviceType) filter.serviceType = query.serviceType;
    if (query.status) filter.status = query.status;

    if (query.startDate || query.endDate) {
      filter.startDate = {};
      if (query.startDate) filter.startDate.$gte = new Date(query.startDate);
      if (query.endDate) filter.startDate.$lte = new Date(query.endDate);
    }
    return this.getBookings(filter, query)
  }

  async searchBookings(keyword: string, query: PaginationQueryDto) {
    const isObjectId = Types.ObjectId.isValid(keyword);
    const searchRegex = new RegExp(keyword, 'i');

    const filter: any = {
      $or: [
        ...(isObjectId ? [{ _id: new Types.ObjectId(keyword) }] : []),
        { 'user.firstname': searchRegex },
        { 'user.lastname': searchRegex },
        { 'agent.user.firstname': searchRegex },
        { 'agent.user.lastname': searchRegex },
      ]
    };

    return this.getBookings(filter, query);
  }


  async getTotalBookings(): Promise<number> {
    return this.bookingModel.countDocuments({});
  }

}
