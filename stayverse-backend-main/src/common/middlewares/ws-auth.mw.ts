import { ConfigService } from '@nestjs/config';
import { Socket } from 'socket.io';
import { AuthGuard } from '../guards/auth.guard';
import { JwtService } from '@nestjs/jwt';

type SocketIOMiddleWare = {
  (client: Socket, next: (err?: Error) => void);
};

export const SocketAuthMiddleware = (
  configService: ConfigService,
  jwtService: JwtService
): SocketIOMiddleWare => {
  return async (client, next) => {
    try {
      const { authorization } = client.handshake.headers;
      const token = (authorization?.split(' ') ?? [])[1];
      const jwtSecret = configService.get<string>('jwt.secret');
      client.data.user = await AuthGuard.validateToken(token, jwtSecret, jwtService);
      next();
    } catch (error) {
      next(error);
    }
  };
};