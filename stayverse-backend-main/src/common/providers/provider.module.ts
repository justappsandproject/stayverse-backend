import { Module } from "@nestjs/common";
import { MailerModule } from "@nestjs-modules/mailer";
import { ConfigModule, ConfigService } from "@nestjs/config";
import { EmailService } from "./email.service";
import { OtpService } from "./otp.service";
import { GoogleMapsService } from "./google-map.service";
import { DojahService } from "./dojah.service";
import { FirebaseService } from "./firebase.service";
import { DOUploadService } from "./digiital-ocean.service";

@Module({
  imports: [
    ConfigModule,
    MailerModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => ({
        transport: {
          host: configService.get<string>("mail.host"),
          port: configService.get<number>("mail.port"),
          secure: true,
          auth: {
            user: configService.get<string>("mail.user"),
            pass: configService.get<string>("mail.pass"),
          },
        },
      }),
    }),
  ],
  providers: [EmailService, OtpService,GoogleMapsService,DojahService,FirebaseService,DOUploadService],
  exports: [EmailService, OtpService,GoogleMapsService,DojahService,FirebaseService,DOUploadService],
})
export class ProviderModule {}
