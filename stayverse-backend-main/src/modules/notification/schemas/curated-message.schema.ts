import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export type CuratedMessageDocument = CuratedMessage & Document;

@Schema({ _id: false })
export class CuratedMessageInteraction {
  @Prop({ type: Types.ObjectId, required: true })
  userId: Types.ObjectId;

  @Prop({ required: true, enum: ['user', 'agent'] })
  role: 'user' | 'agent';

  @Prop()
  viewedAt?: Date;

  @Prop()
  readAt?: Date;

  @Prop({ enum: ['like', 'dislike'], required: false })
  reaction?: 'like' | 'dislike';

  @Prop()
  reactedAt?: Date;
}
export const CuratedMessageInteractionSchema = SchemaFactory.createForClass(
  CuratedMessageInteraction,
);

@Schema({ timestamps: true })
export class CuratedMessage {
  @Prop({ required: true, enum: ['user', 'agent', 'all'] })
  audience: 'user' | 'agent' | 'all';

  @Prop({ required: true, maxlength: 100 })
  title: string;

  @Prop({ required: true, maxlength: 500 })
  body: string;

  @Prop({ required: false, trim: true })
  imageUrl?: string;

  @Prop({ required: false, enum: ['before', 'after'], default: 'after' })
  imagePosition?: 'before' | 'after';

  @Prop({ required: true, enum: ['now', 'scheduled'], default: 'now' })
  sendMode: 'now' | 'scheduled';

  @Prop({ required: false })
  scheduledAt?: Date;

  @Prop({ required: false })
  deliveredAt?: Date;

  @Prop({ required: true, enum: ['pending', 'sent'], default: 'sent' })
  status: 'pending' | 'sent';

  @Prop({ type: Object, default: {} })
  extras: Record<string, string>;

  @Prop({ type: [CuratedMessageInteractionSchema], default: [] })
  interactions: CuratedMessageInteraction[];

  @Prop({ type: Types.ObjectId, required: false })
  createdBy?: Types.ObjectId;
}

export const CuratedMessageSchema = SchemaFactory.createForClass(CuratedMessage);

