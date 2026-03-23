import { Prop, Schema, SchemaFactory } from "@nestjs/mongoose";
import { Document, Types } from "mongoose";

export type ApartmentRatingDocument = ApartmentRating & Document;

@Schema({ timestamps: true })
export class ApartmentRating {
    _id: Types.ObjectId;

    @Prop({ type: Types.ObjectId, ref: 'Apartment', required: true })
    apartmentId: Types.ObjectId;

    @Prop({ type: Types.ObjectId, ref: 'User', required: true })
    userId: Types.ObjectId;

    @Prop({ type: Number, required: true, min: 1, max: 5 })
    rating: number;

    @Prop({ type: String, maxlength: 500, default: null })
    review?: string;
}

export const ApartmentRatingSchema = SchemaFactory.createForClass(ApartmentRating);

ApartmentRatingSchema.index({ apartmentId: 1, userId: 1 }, { unique: true }); // one review per user per apartment

ApartmentRatingSchema.virtual('user', {
    ref: 'User',
    localField: 'userId',
    foreignField: '_id',
    justOne: true,
    options: { select: 'firstname lastname email profilePicture' }
});

ApartmentRatingSchema.virtual('apartment', {
    ref: 'Apartment',
    localField: 'apartmentId',
    foreignField: '_id',
    justOne: true
});

ApartmentRatingSchema.set('toObject', { virtuals: true });
ApartmentRatingSchema.set('toJSON', { virtuals: true });
