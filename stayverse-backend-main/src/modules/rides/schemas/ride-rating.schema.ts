import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';
import { RideSchema } from './rides.schema';

export type RideRatingDocument = RideRating & Document;

@Schema({ timestamps: true })
export class RideRating {
  _id: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'Ride', required: true })
  rideId: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  userId: Types.ObjectId;

  @Prop({ type: Number, required: true, min: 1, max: 5 })
  rating: number;

  @Prop({ type: String })
  review?: string;
}

export const RideRatingSchema = SchemaFactory.createForClass(RideRating);

RideRatingSchema.index({ rideId: 1, userId: 1 }, { unique: true });
RideRatingSchema.virtual('user', {
  ref: 'User',
  localField: 'userId',
    foreignField: '_id',
    justOne: true,
    options: { select: 'firstname lastname email profilePicture' }
});

RideRatingSchema.virtual('ride', {
    ref: 'Ride',
    localField: 'rideId',
    foreignField: '_id',
    justOne: true
});

RideSchema.set('toObject', { virtuals: true });
RideSchema.set('toJSON', { virtuals: true });
