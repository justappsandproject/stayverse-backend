import { Module } from '@nestjs/common';
import { RidesService } from './services/rides.service';
import { RidesController } from './controllers/rides.controller';
import { MongooseModule } from '@nestjs/mongoose';
import { Ride, RideSchema } from './schemas/rides.schema';
import { Favorite, FavoriteSchema } from '../favorite/schemas/favorite.schema';
import { ProviderModule } from 'src/common/providers/provider.module';
import { RideRating, RideRatingSchema } from './schemas/ride-rating.schema';
import { Booking, BookingSchema } from '../booking/schemas/booking.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: Ride.name, schema: RideSchema },
      { name: RideRating.name, schema: RideRatingSchema },
      { name: Booking.name, schema: BookingSchema }
    ]),
    ProviderModule,
  ],
  providers: [RidesService],
  controllers: [RidesController],
  exports: [RidesService]
})
export class RidesModule { }
