import { Global, Module } from '@nestjs/common';
import { NotificationController } from './controllers/notification.controller';
import { ProviderModule } from 'src/common/providers/provider.module';
import { NotificationService } from './services/notification.service';
import { NotificationEvents } from './event/notification.event';
import { NotificationListener } from './listener/notification.listener';

@Global()
@Module({
  imports: [
    ProviderModule
  ],
  providers: [NotificationService,NotificationEvents, NotificationListener],
  controllers: [NotificationController],
  exports: [NotificationEvents],
})
export class NotificationModule {}
