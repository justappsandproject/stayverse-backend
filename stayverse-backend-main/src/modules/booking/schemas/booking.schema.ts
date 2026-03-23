import { Prop, Schema, SchemaFactory } from "@nestjs/mongoose";
import { Document, Types } from "mongoose";
import { ApiProperty } from "@nestjs/swagger";
import { BookingStatus, EscrowStatus, PaymentStatus, ServiceType } from "src/common/constants/enum";
import { PaymentTransaction } from "src/modules/payments/schema/payment-transaction.schema";

export type BookingDocument = Booking & Document;

@Schema({ timestamps: true })
export class Booking {
  @ApiProperty({ enum: ServiceType })
  @Prop({
    type: String,
    enum: ServiceType,
    required: true,
  })
  serviceType: ServiceType;

  @ApiProperty({ type: String, format: 'ObjectId' })
  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  userId: Types.ObjectId;

  @ApiProperty({ type: String, format: 'ObjectId' })
  @Prop({ type: Types.ObjectId, ref: 'Agent', required: true })
  agentId: Types.ObjectId;

  @ApiProperty({ type: String, format: 'ObjectId', required: false })
  @Prop({ type: Types.ObjectId, ref: 'Apartment', required: false })
  apartmentId?: Types.ObjectId;

  @ApiProperty({ type: String, format: 'ObjectId', required: false })
  @Prop({ type: Types.ObjectId, ref: 'Ride', required: false })
  rideId?: Types.ObjectId;

  @ApiProperty({ type: String, format: 'ObjectId', required: false })
  @Prop({ type: Types.ObjectId, ref: 'Chef', required: false })
  chefId?: Types.ObjectId;

  @ApiProperty({ type: 'string', format: 'date-time' })
  @Prop({ required: false })
  startDate?: Date;

  @ApiProperty({ type: 'string', format: 'date-time' })
  @Prop({ required: false })
  endDate?: Date;

  @ApiProperty({ type: 'number' })
  @Prop({ required: true })
  totalPrice: number;

  @ApiProperty({ type: 'number' })
  @Prop({ required: false })
  cautionFee?: number;

  @Prop({ required: false })
  pickupAddress: string;

  @Prop({ type: String, required:false})
  pickupPlaceId: string;

  @ApiProperty({ enum: BookingStatus })
  @Prop({ default: BookingStatus.PENDING, enum: BookingStatus })
  status: BookingStatus

  @ApiProperty({ enum: PaymentStatus })
  @Prop({ default: PaymentStatus.PENDING, enum: PaymentStatus })
  paymentStatus: PaymentStatus;

  @ApiProperty({
    description: 'Indicates if the payment is held in escrow or released to the agent.',
    enum: EscrowStatus,
    example: EscrowStatus.HOLD
  })
  @Prop({
    default: EscrowStatus.HOLD, enum: EscrowStatus
  })
  escrowStatus: EscrowStatus;
  @Prop({
    type: [String],
    required: false,
    default: []
  })
  securityDetails?: string[];

  @Prop({
    type: String,
    required: false,
    default: ''
  })
  notes?: string;
}

export const BookingSchema = SchemaFactory.createForClass(Booking);
BookingSchema.virtual('user', {
  ref: 'User',
  localField: 'userId',
  foreignField: '_id',
  justOne: true,
});

BookingSchema.virtual('agent', {
  ref: 'Agent',
  localField: 'agentId',
  foreignField: '_id',
  justOne: true,
});

BookingSchema.virtual('chef', {
  ref: 'Chef',
  localField: 'chefId',
  foreignField: '_id',
  justOne: true,
});

BookingSchema.virtual('apartment', {
  ref: 'Apartment',
  localField: 'apartmentId',
  foreignField: '_id',
  justOne: true,
});

BookingSchema.virtual('ride', {
  ref: 'Ride',
  localField: 'rideId',
  foreignField: '_id',
  justOne: true,
});

BookingSchema.set('toObject', { virtuals: true });
BookingSchema.set('toJSON', { virtuals: true });