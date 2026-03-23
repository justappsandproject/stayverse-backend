import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { UserController } from './controllers/user.controller';
import { UserService } from './services/user.service';
import { User, UserSchema } from './schemas/user.schema';
import { Booking, BookingSchema } from '../booking/schemas/booking.schema';
import { Agent, AgentSchema } from '../agent/schemas/agent.schema';
import { ProviderModule } from 'src/common/providers/provider.module';
import { ListenerModule } from 'src/common/listener/listener.module';
import { StreamProvider } from 'src/common/providers/stream.provider';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: User.name, schema: UserSchema },
      { name: Booking.name, schema: BookingSchema },
      { name: Agent.name, schema: AgentSchema }
    ]),
    ListenerModule,
    ProviderModule
  ],
  controllers: [UserController],
  providers: [UserService, StreamProvider],
  exports: [UserService],
})
export class UserModule { }
