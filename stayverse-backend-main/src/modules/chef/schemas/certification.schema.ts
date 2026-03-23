import { Prop, Schema, SchemaFactory } from "@nestjs/mongoose";
import { Types } from "mongoose";

export type CertificationDocument = Certification & Document
@Schema({ timestamps: true })
export class Certification {
  @Prop({ type: Types.ObjectId, ref: 'Chef', required: true })
  chefId: Types.ObjectId;

  @Prop({ required: true })
  title: string;

  @Prop({ required: true })
  organization: string;

  @Prop({ type: Date, required: true })
  issuedDate: Date;

  @Prop({ required: true })
  certificateUrl: string;
}

export const CertificationSchema = SchemaFactory.createForClass(Certification);
