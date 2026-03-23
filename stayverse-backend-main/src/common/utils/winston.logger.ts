import { Injectable, LoggerService, OnApplicationShutdown } from '@nestjs/common';
import * as winston from 'winston';
import 'winston-daily-rotate-file'; // Import for side-effects if using daily rotate
import { Logtail } from '@logtail/node';
import { LogtailTransport } from '@logtail/winston';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class WinstonLoggerService implements LoggerService, OnApplicationShutdown {
    private readonly logger: winston.Logger;
    private logtail: Logtail | null = null;

    constructor(private readonly configService: ConfigService) {
        // 1. Define Standard Transports (e.g., File Rotation for local/backup)
        const transports: winston.transport[] = [
            new winston.transports.DailyRotateFile({
                filename: 'logs/app-%DATE%.log',
                datePattern: 'YYYY-MM-DD',
                maxSize: '20m',
                maxFiles: '14d',
                zippedArchive: true,
            }),
            new winston.transports.DailyRotateFile({
                filename: 'logs/error-%DATE%.log',
                datePattern: 'YYYY-MM-DD',
                level: 'error',
                maxSize: '20m',
                maxFiles: '30d',
                zippedArchive: true,
            }),
        ];

        // 2. Add Better Stack (Logtail) Transport in Production or significantly enabled
        // 2. Add Better Stack (Logtail) Transport
        const betterStackToken = this.configService.get<string>('betterStack.sourceToken');

        if (betterStackToken) {
            this.logtail = new Logtail(betterStackToken, {
                endpoint: 'https://in.logs.betterstack.com',
            });
            transports.push(new LogtailTransport(this.logtail));
        }

        // 3. Create the Winston Logger Instance
        this.logger = winston.createLogger({
            level: process.env.LOG_LEVEL || 'info',
            format: winston.format.combine(
                winston.format.timestamp(),
                winston.format.errors({ stack: true }),
                winston.format.json(),
            ),
            transports,
        });

        // 4. Add Console Transport for Development
        if (process.env.NODE_ENV !== 'production') {
            this.logger.add(
                new winston.transports.Console({
                    format: winston.format.combine(
                        winston.format.colorize(),
                        winston.format.simple()
                    ),
                }),
            );
        }
    }

    // 5. Implement standard LoggerService methods
    log(message: any, ...optionalParams: any[]) {
        const context = optionalParams.length > 0 ? optionalParams[optionalParams.length - 1] : undefined;
        this.logger.info(message, { context });
    }


    error(message: any, ...optionalParams: any[]) {
        const trace = optionalParams.length > 1 ? optionalParams[0] : undefined;
        const context = optionalParams.length > 1 ? optionalParams[1] : optionalParams[0];
        this.logger.error(message, { trace, context });
    }


    warn(message: any, ...optionalParams: any[]) {
        const context = optionalParams.length > 0 ? optionalParams[optionalParams.length - 1] : undefined;
        this.logger.warn(message, { context });
    }


    debug(message: any, ...optionalParams: any[]) {
        const context = optionalParams.length > 0 ? optionalParams[optionalParams.length - 1] : undefined;
        this.logger.debug(message, { context });
    }


    verbose(message: any, ...optionalParams: any[]) {
        const context = optionalParams.length > 0 ? optionalParams[optionalParams.length - 1] : undefined;
        this.logger.verbose(message, { context });
    }


    // 6. Flush logs on shutdown
    async onApplicationShutdown(signal?: string) {
        if (this.logtail) {
            await this.logtail.flush();
        }
    }

}
