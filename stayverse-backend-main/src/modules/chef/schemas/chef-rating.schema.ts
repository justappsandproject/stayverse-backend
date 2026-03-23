import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';
import { Chef } from './chef.schema';

export type ChefRatingDocument = ChefRating & Document;

@Schema({ timestamps: true })
export class ChefRating {
  _id: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: Chef.name, required: true })
  chefId: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  userId: Types.ObjectId;

  @Prop({ type: Number, required: true, min: 1, max: 5 })
  rating: number;

  @Prop({ type: String, trim: true })
  review?: string;
}

export const ChefRatingSchema = SchemaFactory.createForClass(ChefRating);

ChefRatingSchema.index({ chefId: 1, userId: 1 }, { unique: true });
ChefRatingSchema.virtual('user', {
  ref: 'User',
  localField: 'userId',
    foreignField: '_id',
    justOne: true,
    options: { select: 'firstname lastname email profilePicture' }
});
ChefRatingSchema.virtual('chef', {
    ref: 'Chef',
    localField: 'chefId',
    foreignField: '_id',
    justOne: true
});
ChefRatingSchema.set('toObject', { virtuals: true });
ChefRatingSchema.set('toJSON', { virtuals: true });