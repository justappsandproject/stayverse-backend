import { Injectable, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Roles } from 'src/common/constants/enum';
import { UserNotification } from '../interfaces/notification.interface';
import { FirebaseService } from 'src/common/providers/firebase.service';
import { EmailService } from 'src/common/providers/email.service';
import { Model } from 'mongoose';
import { User, UserDocument } from 'src/modules/user/schemas/user.schema';
import { BroadcastMessageDto } from '../dto/broadcast-message.dto';
import { CuratedMessage, CuratedMessageDocument } from '../schemas/curated-message.schema';

@Injectable()
export class NotificationService {
    private readonly logger = new Logger(NotificationService.name);

    constructor(
        private readonly firebaseService: FirebaseService,
        private readonly emailService: EmailService,
        @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
        @InjectModel(CuratedMessage.name)
        private readonly curatedMessageModel: Model<CuratedMessageDocument>,
    ) { }

    async sendToUser(
        notification: UserNotification
    ): Promise<boolean> {
        const { token, title, body, extras = {} } = notification;
        if (!token) {
            this.logger.debug('No device token provided');
            return false;
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
            return true;
        } catch (error: any) {
            this.logger.error(`Error sending notification: ${error.message}`);
            return false;
        }
    }

    async broadcastCuratedMessage(payload: BroadcastMessageDto, createdBy?: string) {
        const roleMap: Record<BroadcastMessageDto['audience'], Roles[]> = {
            user: [Roles.USER],
            agent: [Roles.AGENT],
            all: [Roles.USER, Roles.AGENT],
        };

        const curatedMessage = await this.curatedMessageModel.create({
            audience: payload.audience,
            title: payload.title,
            body: payload.body,
            extras: payload.extras ?? {},
            createdBy: createdBy || undefined,
        });

        const targetRoles = roleMap[payload.audience];
        const recipients = await this.userModel
            .find({
                role: { $in: targetRoles },
                notificationsEnabled: true,
                deviceToken: { $nin: [null, ''] },
            })
            .select('_id email role +deviceToken notificationsEnabled')
            .lean();

        let pushSentCount = 0;
        let emailSentCount = 0;
        for (const recipient of recipients) {
            const pushSent = await this.sendToUser({
                token: recipient.deviceToken as string,
                title: payload.title,
                body: payload.body,
                extras: {
                    ...(payload.extras || {}),
                    type: 'curated_message',
                    messageId: String(curatedMessage._id),
                    audience: payload.audience,
                    recipientRole: String(recipient.role),
                },
            });
            if (pushSent) pushSentCount += 1;

            const recipientEmail = String(recipient.email || '').trim();
            if (recipientEmail) {
                const emailHtml = `
                    <div style="font-family: Arial, sans-serif; line-height: 1.5;">
                        <h3 style="margin: 0 0 8px 0;">${payload.title}</h3>
                        <p style="margin: 0;">${payload.body}</p>
                    </div>
                `;
                const emailSent = await this.emailService.sendEmail(
                    recipientEmail,
                    payload.title,
                    emailHtml,
                );
                if (emailSent) emailSentCount += 1;
            }
        }

        return {
            messageId: String(curatedMessage._id),
            audience: payload.audience,
            totalEligible: recipients.length,
            sentCount: pushSentCount,
            failedCount: recipients.length - pushSentCount,
            emailSentCount,
            emailFailedCount: recipients.length - emailSentCount,
        };
    }

    async listCuratedMessagesForRole(role: Roles, page = 1, limit = 20) {
        const audienceFilter =
            role === Roles.AGENT
                ? { audience: { $in: ['agent', 'all'] } }
                : { audience: { $in: ['user', 'all'] } };

        const skip = (page - 1) * limit;
        const [items, total] = await Promise.all([
            this.curatedMessageModel
                .find(audienceFilter)
                .sort({ createdAt: -1 })
                .skip(skip)
                .limit(limit)
                .lean(),
            this.curatedMessageModel.countDocuments(audienceFilter),
        ]);

        return {
            data: items,
            pagination: {
                page,
                limit,
                totalItems: total,
                totalPages: Math.max(1, Math.ceil(total / limit)),
                hasNextPage: skip + items.length < total,
                hasPreviousPage: page > 1,
            },
        };
    }
}
