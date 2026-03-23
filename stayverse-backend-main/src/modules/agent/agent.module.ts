import { Module } from '@nestjs/common';
import { AgentController } from './controllers/agent.controller';
import { AgentService } from './services/agent.service';
import { User, UserSchema } from 'src/modules/user/schemas/user.schema';
import { ProviderModule } from 'src/common/providers/provider.module';
import { MongooseModule } from '@nestjs/mongoose';
import { Agent, AgentSchema } from './schemas/agent.schema';
import { ListenerModule } from 'src/common/listener/listener.module';
import { Favorite, FavoriteSchema } from '../favorite/schemas/favorite.schema';
import { Booking, BookingSchema } from '../booking/schemas/booking.schema';
import { Ride, RideSchema } from '../rides/schemas/rides.schema';
import { Apartment, ApartmentSchema } from '../apartment/schemas/apartment.schema';
import { StreamProvider } from 'src/common/providers/stream.provider';
import { UserModule } from '../user/user.module';
import { Chef, ChefSchema } from '../chef/schemas/chef.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: User.name, schema: UserSchema },
      { name: Agent.name, schema: AgentSchema },
      { name: Favorite.name, schema: FavoriteSchema },
      { name: Booking.name, schema: BookingSchema },
      { name: Ride.name, schema: RideSchema },
      { name: Apartment.name, schema: ApartmentSchema },
      {name:Chef.name, schema :ChefSchema}
    ]),
    ListenerModule,
    ProviderModule,
    UserModule
  ],
  controllers: [AgentController],
  providers: [AgentService,StreamProvider],
})
export class AgentModule { }
