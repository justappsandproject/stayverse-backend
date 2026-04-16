import { Global, Module } from '@nestjs/common';
import { NotificationController } from './controllers/notification.controller';
import { ProviderModule } from 'src/common/providers/provider.module';
import { NotificationService } from './services/notification.service';
import { NotificationEvents } from './event/notification.event';
import { NotificationListener } from './listener/notification.listener';
import { MongooseModule } from '@nestjs/mongoose';
import { User, UserSchema } from '../user/schemas/user.schema';
import { CuratedMessage, CuratedMessageSchema } from './schemas/curated-message.schema';

@Global()
@Module({
  imports: [
    ProviderModule,
    MongooseModule.forFeature([
      { name: User.name, schema: UserSchema },
      { name: CuratedMessage.name, schema: CuratedMessageSchema },
    ]),
  ],
  providers: [NotificationService,NotificationEvents, NotificationListener],
  controllers: [NotificationController],
  exports: [NotificationEvents],
})
export class NotificationModule {}
