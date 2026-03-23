import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';
import { AdminEscrowStatus, EscrowStatus, EscrowType, PayoutType } from 'src/common/constants/enum';
import { Agent } from 'src/modules/agent/schemas/agent.schema';
import { Booking } from 'src/modules/booking/schemas/booking.schema';
import { User } from 'src/modules/user/schemas/user.schema';
import { PaymentTransaction } from './payment-transaction.schema';

export type PaymentEscrowDocument = PaymentEscrow & Document;

@Schema({ timestamps: true })
export class PaymentEscrow {
  @Prop({ type: Types.ObjectId, ref: Booking.name, required: true })
  bookingId: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: User.name, required: true })
  userId: Types.ObjectId;

  @Prop({ required: true })
  totalAmount: number;

  @Prop({ default: 0 })
  amountReleased: number;

  @Prop({ default: 0 })
  lastReleasedDay: number;

  @Prop({
    type: String,
    enum: EscrowStatus,
    default: EscrowStatus.HOLD,
  })
  status: EscrowStatus;

  @Prop({
    type: String,
    enum: PayoutType,
    default: PayoutType.DAILY,
  })
  payoutType: PayoutType;

  @Prop({
    type: String,
    enum: AdminEscrowStatus,
    default: AdminEscrowStatus.RELEASED,
  })
  adminEscrowStatus: AdminEscrowStatus;

  @Prop({ type: Date, required: false })
  releaseDate?: Date;

  @Prop({
    type: String,
    enum: EscrowType,
    default: EscrowType.APARTMENT,
  })
  referenceType?: EscrowType;

  @Prop({ type: Types.ObjectId, ref: PaymentTransaction.name, required: false })
  transactionId?: Types.ObjectId;

}

export const PaymentEscrowSchema = SchemaFactory.createForClass(PaymentEscrow);


