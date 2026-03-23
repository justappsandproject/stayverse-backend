import { Module } from '@nestjs/common';
import { ApartmentController } from './controllers/apartment.controller';
import { ApartmentService } from './services/apartment.service';
import { MongooseModule } from '@nestjs/mongoose';
import { Apartment, ApartmentSchema } from './schemas/apartment.schema';
import { ProviderModule } from 'src/common/providers/provider.module';
import { Agent, AgentSchema } from '../agent/schemas/agent.schema';
import { ApartmentRating, ApartmentRatingSchema } from './schemas/apartment-rating.schema';
import { Booking, BookingSchema } from '../booking/schemas/booking.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: Apartment.name, schema: ApartmentSchema },
      { name: Agent.name, schema: AgentSchema },
      { name: ApartmentRating.name, schema: ApartmentRatingSchema },
      { name: Booking.name, schema: BookingSchema }
    ]),
    ProviderModule,
  ],
  controllers: [ApartmentController],
  providers: [ApartmentService],
  exports: [ApartmentService]
})
export class ApartmentModule { }
