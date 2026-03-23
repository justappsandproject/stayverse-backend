import { Module } from '@nestjs/common';
import { EventEmitterModule } from '@nestjs/event-emitter';
import { UserEventListener } from './user.listener';
import { ProviderModule } from '../providers/provider.module';
@Module({
  imports: [EventEmitterModule.forRoot(), ProviderModule], 
  providers: [UserEventListener], 
  exports: [UserEventListener], 
})
export class ListenerModule {}
