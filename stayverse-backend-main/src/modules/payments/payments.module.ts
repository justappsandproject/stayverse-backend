import { Module } from '@nestjs/common';
import { PaymentsController } from './controller/payments.controller';
import { PaymentsService } from './service/payments.service';
import { PaystackService } from './service/paystack.service';
import { MongooseModule } from '@nestjs/mongoose';
import { PaymentTransaction, PaymentTransactionSchema } from './schema/payment-transaction.schema';
import { PaymentEscrow, PaymentEscrowSchema } from './schema/payment-escrow.schema';
import { Booking, BookingSchema } from '../booking/schemas/booking.schema';
import { User, UserSchema } from '../user/schemas/user.schema';
import { Agent, AgentSchema } from '../agent/schemas/agent.schema';
import { PaystackWebhookService } from './service/paystack-webhook.service';
import { PaymentsCronService } from './cron/payment.cron';

@Module({
  imports: [
    MongooseModule.forFeature([{name:PaymentTransaction.name,schema:PaymentTransactionSchema},
      {name: PaymentEscrow.name, schema:PaymentEscrowSchema},
      {name: User.name, schema: UserSchema},
      {name: Agent.name, schema: AgentSchema},
      {name: Booking.name, schema: BookingSchema}
    ])
  ],
  controllers: [PaymentsController],
  providers: [PaymentsService, PaystackService, PaystackWebhookService,PaymentsCronService],
  exports: [PaymentsService],
})
export class PaymentsModule { }
