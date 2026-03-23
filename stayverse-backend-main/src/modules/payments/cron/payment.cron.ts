import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { PaymentsService } from '../service/payments.service';

@Injectable()
export class PaymentsCronService {
  private readonly logger = new Logger(PaymentsCronService.name);

  constructor(private readonly paymentsService: PaymentsService) { }

  @Cron(CronExpression.EVERY_5_MINUTES)
  async releaseDailyEscrowPayments() {
    try {
      this.logger.log('Starting daily escrow disbursement...');
      const result = await this.paymentsService.processDailyDisbursements();
      this.logger.log(`Daily escrow disbursement completed: ${JSON.stringify(result ?? 'OK')}`);
    } catch (error) {
      this.logger.error(`Error in daily escrow disbursement: ${error.message}`, error.stack);
    }
  }

  @Cron(CronExpression.EVERY_5_MINUTES)
  async releaseWholeEscrowPayments() {
    try {
      this.logger.log('Starting whole escrow release...');
      const result = await this.paymentsService.processWholeEscrowReleases();
      this.logger.log(`Whole escrow release completed: ${JSON.stringify(result ?? 'OK')}`);
    } catch (error) {
      this.logger.error(`Error in whole escrow release: ${error.message}`, error.stack);
    }
  }
}
