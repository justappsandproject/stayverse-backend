import { Module } from '@nestjs/common';
import { FavoriteController } from './controllers/favorite.controller';
import { FavoriteService } from './services/favorite.service';
import { MongooseModule } from '@nestjs/mongoose';
import { Favorite, FavoriteSchema } from './schemas/favorite.schema';
import { Apartment, ApartmentSchema } from '../apartment/schemas/apartment.schema';
import { Ride, RideSchema } from '../rides/schemas/rides.schema';
import { Chef, ChefSchema } from '../chef/schemas/chef.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: Favorite.name, schema: FavoriteSchema },
      { name: Apartment.name, schema: ApartmentSchema },
      { name: Ride.name, schema: RideSchema },
      { name: Chef.name, schema: ChefSchema }])
  ],
  controllers: [FavoriteController],
  providers: [FavoriteService]
})
export class FavoriteModule { }
