import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';
import { Types } from 'mongoose';
import { TransactionPaymentStatus, TransactionType } from 'src/common/constants/enum';

export type PaymentTransactionDocument = PaymentTransaction & Document;

@Schema({ timestamps: true })
export class PaymentTransaction {
  @Prop({ required: true })
  reference: string; 

  @Prop({ required: true })
  amount: number;  

  @Prop({ required: true, enum:TransactionType})
  type: TransactionType; 

  @Prop({ required: true, enum: TransactionPaymentStatus })
  status: TransactionPaymentStatus;

  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  userId: Types.ObjectId;
 
  @Prop()
  description?: string;  

  @Prop({ type: Object })
  metadata?: Record<string, any>; 
}

export const PaymentTransactionSchema = SchemaFactory.createForClass(PaymentTransaction);
