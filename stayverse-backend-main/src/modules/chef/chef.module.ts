import { Module } from '@nestjs/common';
import { ChefController } from './controllers/chef.controller';
import { ChefService } from './services/chef.service';
import { MongooseModule } from '@nestjs/mongoose';
import { Certification, CertificationSchema } from './schemas/certification.schema';
import { Experience, ExperienceSchema } from './schemas/experience.schema';
import { Chef, ChefSchema } from './schemas/chef.schema';
import { Favorite, FavoriteSchema } from '../favorite/schemas/favorite.schema';
import { ProviderModule } from 'src/common/providers/provider.module';
import { Feature, FeatureSchema } from './schemas/feaure.schema';
import { ChefRating, ChefRatingSchema } from './schemas/chef-rating.schema';
import { ChefProposal, ChefProposalSchema } from './schemas/chef-proposal.schema';
import { NotificationEvents } from '../notification/event/notification.event';
import { Agent, AgentSchema } from '../agent/schemas/agent.schema';
import { User, UserSchema } from '../user/schemas/user.schema';
import { PaymentEscrow, PaymentEscrowSchema } from '../payments/schema/payment-escrow.schema';
import { Booking, BookingSchema } from '../booking/schemas/booking.schema';
import { PaymentTransaction, PaymentTransactionSchema } from '../payments/schema/payment-transaction.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: Certification.name, schema: CertificationSchema },
      { name: Experience.name, schema: ExperienceSchema },
      { name: Chef.name, schema: ChefSchema },
      { name: Favorite.name, schema: FavoriteSchema },
      { name: Feature.name, schema: FeatureSchema },
      { name: ChefRating.name, schema: ChefRatingSchema },
      { name: ChefProposal.name, schema: ChefProposalSchema },
      { name: Booking.name, schema: BookingSchema },
      { name: PaymentEscrow.name, schema: PaymentEscrowSchema },
      { name: Chef.name, schema: ChefSchema },
      { name: PaymentTransaction.name, schema: PaymentTransactionSchema },
      { name: User.name, schema: UserSchema },
      { name: Agent.name, schema: AgentSchema }
    ]),
    ProviderModule,
  ],
  controllers: [ChefController],
  providers: [ChefService, NotificationEvents],
  exports: [ChefService]
})
export class ChefModule { }
