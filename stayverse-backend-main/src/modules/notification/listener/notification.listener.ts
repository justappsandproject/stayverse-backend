import { Injectable } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { NotificationService } from '../services/notification.service';
import { UserNotification } from '../interfaces/notification.interface';
import { NotificationEventsConst } from 'src/common/constants/event.constant';

@Injectable()
export class NotificationListener {
  constructor(private readonly NotificationService: NotificationService) {}

  @OnEvent(NotificationEventsConst.NOTIFICATION_CREATED)
  async handleNotificationCreated(notification: UserNotification) {
    await this.NotificationService.sendToUser(notification);
  }
}
