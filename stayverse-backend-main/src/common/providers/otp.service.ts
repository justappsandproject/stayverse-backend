import { Injectable, Logger } from "@nestjs/common";
import { EmailService } from "./email.service";
import { otpEmailTemplate } from "./template/otp-email.template";
import { welcomeEmailTemplate } from './template/welcome-email.template'
import { EmailType } from "../constants/enum";
import { ConfigService } from "@nestjs/config";

interface EmailResponse {
    status: boolean;
    otp?: string;
}

@Injectable()
export class OtpService {
    private readonly logger = new Logger(OtpService.name);

    constructor(private readonly emailService: EmailService, private configService: ConfigService) { }
    async sendEmailMessage(email: string, name: string, type: EmailType): Promise<EmailResponse> {
        let subject: string;
        let message: string;
        let otp: string | undefined = undefined;
        const baseurl = this.configService.get<string>('app.base_url');
        if (type === EmailType.EMAIL_VERIFICATION) {
            otp = Math.floor(100000 + Math.random() * 900000).toString();
            subject = "Email Confirmation";
            message = otpEmailTemplate(name, otp, 'verification', baseurl);
        } else if (type === EmailType.RESET_PASSWORD) {
            otp = Math.floor(100000 + Math.random() * 900000).toString();
            subject = "Password Reset OTP";
            message = otpEmailTemplate(name, otp, 'reset', baseurl);
        } else {
            subject = "Welcome to Our Platform";
            message = welcomeEmailTemplate(name);
        }

        try {
            const response = await this.emailService.sendEmail(email, subject, message);
            if (!response) {
                this.logger.warn(`Failed to send ${type} email to ${email}`);
                return { status: false };
            }
            return { status: true, otp };
        } catch (error) {
            this.logger.error(`Error sending ${type} email to ${email}: ${error.message}`);
            return { status: false };
        }
    }
}
