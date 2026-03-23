
import {
    ExceptionFilter,
    Catch,
    ArgumentsHost,
    HttpException,
    BadRequestException,
    Logger,
} from '@nestjs/common';
import { formatResponse, ResponseFormat } from '../utils/response-formatting.utils';

@Catch(HttpException)
export class HttpExceptionFilter implements ExceptionFilter {
    private readonly logger = new Logger(HttpExceptionFilter.name);

    catch(exception: HttpException, host: ArgumentsHost) {
        const ctx = host.switchToHttp();
        const response = ctx.getResponse();
        const request = ctx.getRequest();
        const status = exception.getStatus();

        // Log server errors as errors, client errors as warnings
        if (status >= 500) {
            this.logger.error(
                `${request.method} ${request.url} ${status} - ${exception.message}`,
                exception.stack,
            );
        } else if (status >= 400) {
            this.logger.warn(
                `${request.method} ${request.url} ${status} - ${exception.message}`,
            );
        }

        const payload: ResponseFormat = {
            statusCode: status,
            message: exception.message || 'An error occurred.'
        };

        if (exception instanceof BadRequestException) {
            const validationErrors = exception.getResponse();
            if (Array.isArray(validationErrors['message'])) {
                payload['message'] = validationErrors['message'][0];
                payload['error'] = validationErrors['message']
            } else {
                payload['message'] = validationErrors['message']
                payload['error'] = [validationErrors['message']]
            }
        }

        response.status(status).json(
            formatResponse(payload),
        );
    }
}
