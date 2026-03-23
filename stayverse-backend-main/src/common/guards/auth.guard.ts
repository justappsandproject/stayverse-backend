import {
  CanActivate,
  ExecutionContext,
  Injectable,
  Logger,
  SetMetadata,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { Request } from 'express';
import { ConfigService } from '@nestjs/config';
import { Reflector } from '@nestjs/core';
import { plainToClass } from 'class-transformer';
import { JwtPayloadDto } from '../dtos/jwt-payload.dto';
import { validate } from 'class-validator';


export const IS_PUBLIC_KEY = 'isPublic';
export const Public = () => SetMetadata(IS_PUBLIC_KEY, true);

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    private jwtService: JwtService,
    private configService: ConfigService,
    private reflector: Reflector
  ) { }

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (isPublic) {
      return true;
    }

    const request = context.switchToHttp().getRequest();
    const token = this.extractTokenFromHeader(request);
    const jwtSecret = this.configService.get<string>('jwt.secret')
    request['user'] = await AuthGuard.validateToken(token, jwtSecret, this.jwtService);
    return true;
  }

  private extractTokenFromHeader(request: Request): string | undefined {
    const [type, token] = request.headers.authorization?.split(' ') ?? [];
    return type === 'Bearer' ? token : undefined;
  }

  static async validateToken(token: string, jwtSecret: string, jwtService: JwtService) {
    if (!token) {
      throw new UnauthorizedException();
    }
    try {
      const payload = await jwtService.verifyAsync(
        token,
        {
          secret: jwtSecret
        }
      );
      const payloadDto = plainToClass(JwtPayloadDto, payload);
      const validationErrors = await validate(payloadDto);

      if (validationErrors.length > 0) {
        Logger.warn(`Invalid JWT payload: ${JSON.stringify(validationErrors)}`, 'AuthGuard');
        throw new UnauthorizedException('Invalid token payload. Please login again.');
      }
      return payload;
    } catch (error) {
      if (error instanceof UnauthorizedException) {
        throw error;
      }
      if (error.name === 'TokenExpiredError') {
        throw new UnauthorizedException('Your session has expired. Please log in again');
      }
      throw new UnauthorizedException('Invalid token. Please log in again');
    }
  }
}