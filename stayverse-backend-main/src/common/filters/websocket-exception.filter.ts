import { Catch, ArgumentsHost, HttpException } from '@nestjs/common';
import { BaseWsExceptionFilter, WsException } from '@nestjs/websockets';


@Catch(WsException, HttpException)
export class WebSocketExceptionFilter extends BaseWsExceptionFilter {
    catch(exception: unknown, host: ArgumentsHost) {
        const client = host.switchToWs().getClient();

        let message = 'An error occurred';
        if (exception instanceof WsException) {
            const error = exception.getError();
            message = typeof error === 'string' ? error : error['message'];
        } else if (exception instanceof HttpException) {
            message = exception.getResponse()['message'] || exception.message;
        } else if (exception instanceof Error) {
            message = exception.message;
        }

        // Emit the error to the client
        client.emit('error', { message });
    }
}
