import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Exclude } from 'class-transformer';
import mongoose, { Document, Types } from 'mongoose';
import { ServiceType } from 'src/common/constants/enum';
import { User } from 'src/modules/user/schemas/user.schema';
export type AgentDocument = Agent & Document;

@Schema({ timestamps: true })
export class Agent {
    @Prop({ type: String, enum: ServiceType, required: true })
    serviceType: ServiceType;

    @Prop({ type: mongoose.Types.ObjectId, ref: User.name, required: true })
    userId: mongoose.Types.ObjectId;

    @Prop({ type: Boolean, default: false })
    isDeleted: boolean;
}

export const AgentSchema = SchemaFactory.createForClass(Agent);

AgentSchema.pre(/^find/, function (next) {
    if (this instanceof mongoose.Query) {
        this.find({ isDeleted: { $ne: true } });
    }
    next();
});

AgentSchema.virtual('user', {
    ref: 'User',
    localField: 'userId',
    foreignField: '_id',
    justOne: true,
});
AgentSchema.set('toObject', { virtuals: true });
AgentSchema.set('toJSON', { virtuals: true });
