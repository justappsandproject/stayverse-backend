import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { OtpService } from '../providers/otp.service';
import { EmailType } from '../constants/enum';

@Injectable()
export class UserEventListener {
  private readonly logger = new Logger(UserEventListener.name);
  constructor(
    private  otpService : OtpService  
  )
  {}
  @OnEvent('user.verified')
  handleUserVerified(payload: { email: string; name :string }) {
    this.otpService.sendEmailMessage(payload.email,payload.name,EmailType.WELCOME);  }
}
