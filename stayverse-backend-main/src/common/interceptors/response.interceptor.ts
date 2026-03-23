// src/interceptors/response.interceptor.ts

import {
    Injectable,
    NestInterceptor,
    ExecutionContext,
    CallHandler,
    Logger,
} from '@nestjs/common';
import { Observable, map, tap } from 'rxjs';
import { formatResponse } from '../utils/response-formatting.utils';

@Injectable()
export class ResponseInterceptor implements NestInterceptor {
    private readonly logger = new Logger(ResponseInterceptor.name);

    intercept(
        context: ExecutionContext,
        next: CallHandler,
    ): Observable<any> {
        const request = context.switchToHttp().getRequest();
        const now = Date.now();

        return next.handle().pipe(
            tap(() => {
                const ms = Date.now() - now;
                if (ms > 3000) {
                    this.logger.warn(
                        `Slow response: ${request.method} ${request.url} — ${ms}ms`,
                    );
                }
            }),
            map((data) => {
                const ctx = context.switchToHttp();
                const response = ctx.getResponse();
                const statusCode = response.statusCode ?? 200;

                // If controller already formatted response, return it as-is
                if (data && typeof data === 'object' && 'message' in data && 'data' in data) {
                    return formatResponse({
                        statusCode,
                        message: data.message,
                        data: data.data,
                    });
                }

                // Otherwise, let interceptor wrap it
                const isPrimitive =
                    ['string', 'number', 'boolean'].includes(typeof data);

                return formatResponse({
                    statusCode,
                    message: isPrimitive
                        ? String(data)
                        : data?.message ?? 'Request successful',
                    data: !isPrimitive ? data : null,
                });
            }),
        );

    }
}
