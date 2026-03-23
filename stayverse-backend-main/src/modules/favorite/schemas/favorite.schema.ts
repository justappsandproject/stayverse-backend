import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { ApiProperty } from '@nestjs/swagger';
import { Document, Types } from 'mongoose';
import { FavoriteStatus, ServiceType } from 'src/common/constants/enum';
import { Agent } from 'src/modules/agent/schemas/agent.schema';
import { Apartment } from 'src/modules/apartment/schemas/apartment.schema';
import { Chef } from 'src/modules/chef/schemas/chef.schema';
import { Ride } from 'src/modules/rides/schemas/rides.schema';
import { User } from 'src/modules/user/schemas/user.schema';

export type FavoriteDocument = Favorite & Document;

@Schema({ timestamps: true })
export class Favorite {
  @ApiProperty({ type: String, format: 'ObjectId' })
  @Prop({ type: Types.ObjectId, ref: User.name, required: true })
  userId: Types.ObjectId;

  @ApiProperty({ type: String, format: 'ObjectId' })
  @Prop({ type: Types.ObjectId, ref: Agent.name, required: true })
  agentId: Types.ObjectId

  @ApiProperty({ type: String, format: 'ObjectId', required: false })
  @Prop({ type: Types.ObjectId, ref: Apartment.name, required: false })
  apartmentId?: Types.ObjectId;

  @ApiProperty({ type: String, format: 'ObjectId', required: false })
  @Prop({ type: Types.ObjectId, ref: Ride.name, required: false })
  rideId?: Types.ObjectId;

  @ApiProperty({ type: String, format: 'ObjectId', required: false })
  @Prop({ type: Types.ObjectId, ref: Chef.name, required: false })
  chefId?: Types.ObjectId;

  @Prop({
    type: String,
    required: true,
    enum: Object.values(ServiceType),
  })
  serviceType: ServiceType;

  @Prop({
    type: String,
    enum: Object.values(FavoriteStatus),
    default: FavoriteStatus.ACTIVE
  })
  status: FavoriteStatus;
}

export const FavoriteSchema = SchemaFactory.createForClass(Favorite);

FavoriteSchema.virtual('user', {
  ref: 'User',
  localField: 'userId',
  foreignField: '_id',
  justOne: true,
});

FavoriteSchema.virtual('agent', {
  ref: 'Agent',
  localField: 'agentId',
  foreignField: '_id',
  justOne: true,
});

FavoriteSchema.virtual('chef', {
  ref: 'Chef',
  localField: 'chefId',
  foreignField: '_id',
  justOne: true,
});

FavoriteSchema.virtual('apartment', {
  ref: 'Apartment',
  localField: 'apartmentId',
  foreignField: '_id',
  justOne: true,
});

FavoriteSchema.virtual('ride', {
  ref: 'Ride',
  localField: 'rideId',
  foreignField: '_id',
  justOne: true,
});
FavoriteSchema.set('toObject', { virtuals: true });
FavoriteSchema.set('toJSON', { virtuals: true });