import { Prop, Schema, SchemaFactory } from "@nestjs/mongoose";
import { Types } from "mongoose";
import { Chef } from "./chef.schema";

export type ExperienceDocument = Experience & Document
@Schema({ timestamps: true })
export class Experience {
  @Prop({ type: Types.ObjectId, ref: 'Chef', required: true })
  chefId: Types.ObjectId;

  @Prop({ required: true })
  title: string;

  @Prop({ required: true })
  company: string;

  @Prop({ required: true })
  description: string;

  @Prop({ type: Date, required: true })
  startDate: Date;

  @Prop({ type: Date, default: null })
  endDate?: Date;

  @Prop({ type: Boolean, default: false })
  stillWorking?: boolean;

  @Prop({ required: false })
  address: string;

  @Prop({ required: true })
  stayVerseJob: boolean;
}

export const ExperienceSchema = SchemaFactory.createForClass(Experience);
