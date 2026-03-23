import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export type FeatureDocument = Feature & Document;

@Schema({ timestamps: true })
export class Feature {
  @Prop({ type: Types.ObjectId, ref: 'Chef', required: true })
  chefId: Types.ObjectId;

  @Prop({ required: true })
  description: string;

  @Prop({
    type: [
      {
        _id: false, 
        imageUrl: { type: String, required: true },
        description: { type: String, required: true },
      },
    ],
    default: [],
  })
  featuredImages: {
    imageUrl: string;
    description: string;
  }[];
}

export const FeatureSchema = SchemaFactory.createForClass(Feature);
