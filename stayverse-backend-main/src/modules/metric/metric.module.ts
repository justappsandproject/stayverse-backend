import { Module } from '@nestjs/common';
import { MetricController } from './controllers/metric.controller';
import { MetricService } from './services/metric.service';
import { ApartmentModule } from '../apartment/apartment.module';
import { RidesModule } from '../rides/rides.module';
import { ChefModule } from '../chef/chef.module';
import { BookingModule } from '../booking/booking.module';
import { UserModule } from '../user/user.module';

@Module({
   imports: [ApartmentModule, RidesModule, ChefModule, BookingModule, UserModule],
  controllers: [MetricController],
  providers: [MetricService]
})
export class MetricModule {}
