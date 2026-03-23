import { Injectable, Logger } from '@nestjs/common';

@Injectable()
export class AppService {
  private readonly logger = new Logger(AppService.name);

  getHello(): string {
    return 'Hello World!';
  }

  getTestLog(): string {
    this.logger.log('This is a test INFO log for Better Stack');
    this.logger.error('This is a test ERROR log for Better Stack');
    this.logger.warn('This is a test WARN log for Better Stack');
    return 'Logs have been sent! Check your Better Stack dashboard.';
  }
}
