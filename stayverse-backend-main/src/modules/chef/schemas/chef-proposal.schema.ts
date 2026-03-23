import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';
import { ProposalStatus } from 'src/common/constants/enum';

export type ChefProposalDocument = ChefProposal & Document;

@Schema({ timestamps: true })
export class ChefProposal {
  _id: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'Chef', required: true })
  chefId: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  userId: Types.ObjectId;

  @Prop({ type: Number, required: true })
  price: number;

  @Prop({ type: String, required: true })
  description: string;

  @Prop({ type: String, enum: ProposalStatus, default: ProposalStatus.PENDING })
  status: ProposalStatus;

  @Prop({ type: Date, default: Date.now })
  sentAt: Date;

  @Prop({type:Date, required: false})
  date:Date;

  @Prop({type:Types.ObjectId, ref:'Booking', required:false})
  bookingId?:Types.ObjectId
}

export const ChefProposalSchema = SchemaFactory.createForClass(ChefProposal);
ChefProposalSchema.virtual('chef', {
    ref: 'Chef',
    localField: 'chefId',
    foreignField: '_id',
    justOne: true
});
ChefProposalSchema.set('toObject', { virtuals: true });
ChefProposalSchema.set('toJSON', { virtuals: true });

