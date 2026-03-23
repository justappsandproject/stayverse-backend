import { Injectable, Logger } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { MailerService } from "@nestjs-modules/mailer";

@Injectable()
export class EmailService {
    private readonly logger = new Logger(EmailService.name);

    constructor(
        private configService: ConfigService,
        private mailerService: MailerService
    ) { }

    async sendEmail(to: string, subject: string, message: string) {
        try {
            const mailOptions = {
                to,
                from: this.configService.get<string>('mail.user'),
                subject,
                html: message,
            };
            await this.mailerService.sendMail(mailOptions);
            return true;
        } catch (error) {
            this.logger.error(`Failed to send email to ${to}: ${error.message}`, error.stack);
            return false;
        }
    }
}
