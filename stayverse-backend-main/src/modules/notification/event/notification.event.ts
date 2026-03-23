import { Injectable } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { NotificationEventsConst } from 'src/common/constants/event.constant';
import { UserNotification } from '../interfaces/notification.interface';

@Injectable()
export class NotificationEvents {
  constructor(private eventEmitter: EventEmitter2) {}

  emitNotification(payload: UserNotification) {
    this.eventEmitter.emit(NotificationEventsConst.NOTIFICATION_CREATED, payload);
  }
}
