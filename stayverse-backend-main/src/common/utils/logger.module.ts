import { Global, Module } from '@nestjs/common';
import { WinstonLoggerService } from './winston.logger';
import { ConfigModule } from '@nestjs/config';

@Global()
@Module({
    imports: [ConfigModule],
    providers: [WinstonLoggerService],
    exports: [WinstonLoggerService],
})
export class LoggerModule { }
