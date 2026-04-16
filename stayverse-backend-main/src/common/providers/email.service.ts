import { Injectable, Logger } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { MailerService } from "@nestjs-modules/mailer";

@Injectable()
export class EmailService {
    private readonly logger = new Logger(EmailService.name);
    private readonly emailTimeoutMs: number;

    constructor(
        private configService: ConfigService,
        private mailerService: MailerService
    ) {
        this.emailTimeoutMs = Number(
            this.configService.get<string>("mail.timeoutMs") || 7000
        );
    }

    async sendEmail(to: string, subject: string, message: string) {
        try {
            const mailOptions = {
                to,
                from: this.configService.get<string>('mail.user'),
                subject,
                html: message,
            };
            await Promise.race([
                this.mailerService.sendMail(mailOptions),
                new Promise((_, reject) =>
                    setTimeout(
                        () => reject(new Error(`Email timeout after ${this.emailTimeoutMs}ms`)),
                        this.emailTimeoutMs
                    )
                ),
            ]);
            return true;
        } catch (error) {
            this.logger.error(`Failed to send email to ${to}: ${error.message}`, error.stack);
            return false;
        }
    }
}
