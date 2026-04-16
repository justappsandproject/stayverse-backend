import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export type CuratedMessageDocument = CuratedMessage & Document;

@Schema({ timestamps: true })
export class CuratedMessage {
  @Prop({ required: true, enum: ['user', 'agent', 'all'] })
  audience: 'user' | 'agent' | 'all';

  @Prop({ required: true, maxlength: 100 })
  title: string;

  @Prop({ required: true, maxlength: 500 })
  body: string;

  @Prop({ type: Object, default: {} })
  extras: Record<string, string>;

  @Prop({ type: Types.ObjectId, required: false })
  createdBy?: Types.ObjectId;
}

export const CuratedMessageSchema = SchemaFactory.createForClass(CuratedMessage);

