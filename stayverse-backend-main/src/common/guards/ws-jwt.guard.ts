import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { AuthGuard } from './auth.guard';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { Socket } from 'socket.io';
@Injectable()
export class WsJwtAuthGuard implements CanActivate {
  constructor(private configService: ConfigService, private jwtService: JwtService) { }

  async canActivate(context: ExecutionContext) {
    if (context.getType() !== 'ws') {
      return true;
    }
    const client = context.switchToWs().getClient<Socket>();
    const { authorization } = client.handshake.headers;
    const token = (authorization?.split(' ') ?? [])[1];
    if (!token) {
      return false; 
    }

    const jwtSecret = this.configService.get<string>('jwt.secret');
    const payload = await AuthGuard.validateToken(token, jwtSecret, this.jwtService);

    client.data.user = payload;
    return true;
  }
}
