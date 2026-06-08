import { Injectable, Logger, OnModuleInit } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { MailerService } from "@nestjs-modules/mailer";

const PLACEHOLDER_MAIL_VALUES = new Set([
    "test",
    "your_mailtrap_user",
    "your_mailtrap_pass",
    "your_mail_username",
    "your_mail_password",
]);

@Injectable()
export class EmailService implements OnModuleInit {
    private readonly logger = new Logger(EmailService.name);
    private readonly emailTimeoutMs: number;
    private mailConfigured = false;

    constructor(
        private configService: ConfigService,
        private mailerService: MailerService
    ) {
        this.emailTimeoutMs = Number(
            this.configService.get<string>("mail.timeoutMs") || 15000
        );
    }

    onModuleInit() {
        const host = this.configService.get<string>("mail.host");
        const user = this.configService.get<string>("mail.user");
        const pass = this.configService.get<string>("mail.pass");
        const from = this.configService.get<string>("mail.from");

        this.mailConfigured = Boolean(
            host &&
            user &&
            pass &&
            !PLACEHOLDER_MAIL_VALUES.has(user) &&
            !PLACEHOLDER_MAIL_VALUES.has(pass)
        );

        if (!this.mailConfigured) {
            this.logger.error(
                "MAIL_HOST, MAIL_USER, and MAIL_PASS are missing or still set to placeholder values. Verification emails will not be delivered."
            );
            return;
        }

        this.logger.log(
            `Mail transport configured (host=${host}, port=${this.configService.get<number>("mail.port")}, from=${from || user})`
        );
    }

    async sendEmail(to: string, subject: string, message: string) {
        if (!this.mailConfigured) {
            this.logger.error(`Skipped sending "${subject}" to ${to}: mail is not configured`);
            return false;
        }

        try {
            const fromAddress =
                this.configService.get<string>("mail.from") ||
                this.configService.get<string>("mail.user");
            const mailOptions = {
                to,
                from: fromAddress,
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
            this.logger.log(`Email sent to ${to}: ${subject}`);
            return true;
        } catch (error) {
            this.logger.error(`Failed to send email to ${to}: ${error.message}`, error.stack);
            return false;
        }
    }
}
