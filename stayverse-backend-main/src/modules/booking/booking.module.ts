import { Module } from '@nestjs/common';
import { BookingService } from './services/booking.service';
import { BookingController } from './controllers/booking.controller';
import { Booking, BookingSchema } from './schemas/booking.schema';
import { MongooseModule } from '@nestjs/mongoose';
import { Apartment, ApartmentSchema } from '../apartment/schemas/apartment.schema';
import { Ride, RideSchema } from '../rides/schemas/rides.schema';
import { Chef, ChefSchema } from '../chef/schemas/chef.schema';
import { Agent, AgentSchema } from '../agent/schemas/agent.schema';
import { User, UserSchema } from '../user/schemas/user.schema';
import { PaymentTransaction, PaymentTransactionSchema } from '../payments/schema/payment-transaction.schema';
import { PaymentsModule } from '../payments/payments.module';
import { ProviderModule } from 'src/common/providers/provider.module';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: Booking.name, schema: BookingSchema },
      { name: Apartment.name, schema: ApartmentSchema },
      { name: Ride.name, schema: RideSchema },
      { name: User.name, schema: UserSchema },
      { name: Chef.name, schema: ChefSchema },
      { name: PaymentTransaction.name, schema: PaymentTransactionSchema },
      { name: Agent.name, schema: AgentSchema },
    ]),
    ProviderModule,
    PaymentsModule
  ],
  providers: [BookingService],
  controllers: [BookingController],
  exports: [BookingService]
})
export class BookingModule { }
