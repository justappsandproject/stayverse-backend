import { Injectable, Logger } from '@nestjs/common';
import { UserNotification } from '../interfaces/notification.interface';
import { FirebaseService } from 'src/common/providers/firebase.service';

@Injectable()
export class NotificationService {
    private readonly logger = new Logger(NotificationService.name);

    constructor(private readonly firebaseService: FirebaseService) { }

    async sendToUser(
        notification: UserNotification
    ) {
        const { token, title, body, extras = {} } = notification;
        if (!token) {
            this.logger.debug('No device token provided');
            return;
        }

        const sound = 'default'; 
        const message = {
            token,
            notification: { title, body },
            data: extras,
            android: {
                priority: 'high' as const,
                notification: {
                    sound,
                    channelId: sound,
                },
            },
            apns: {
                payload: {
                    aps: {
                        contentAvailable: true,
                        sound: `${sound}.WAV`,
                    },
                },
            },
            webpush: {
                headers: { Urgency: 'high' },
            },
        };

        try {
            const response = await this.firebaseService.getMessaging().send(message);
            this.logger.log(`Notification sent to token: ${token}`);
            this.logger.debug(`Response: ${JSON.stringify(response)}`);
        } catch (error: any) {
            this.logger.error(`Error sending notification: ${error.message}`);
        }
    }
}
