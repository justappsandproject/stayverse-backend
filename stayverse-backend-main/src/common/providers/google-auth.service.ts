import { Injectable, UnauthorizedException, Logger } from '@nestjs/common';
import { OAuth2Client } from 'google-auth-library';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class GoogleAuthService {
  private readonly logger = new Logger(GoogleAuthService.name);
  private googleClient: OAuth2Client;

  constructor(private readonly configService: ConfigService) {
    this.googleClient = new OAuth2Client(
      this.configService.get<string>('google.clientId'),
    );
  }

  async verifyToken(token: string, tokenType: 'idToken' | 'accessToken' = 'accessToken') {
    try {
      if (tokenType === 'idToken') {
        const ticket = await this.googleClient.verifyIdToken({
          idToken: token,
          audience: this.configService.get<string>('google.clientId'),
        });

        const payload = ticket.getPayload();
        if (!payload?.email) throw new UnauthorizedException('Invalid Google ID token');
        return  payload;
      }

      const tokenInfo = await this.googleClient.getTokenInfo(token);
      if (!tokenInfo.email) throw new UnauthorizedException('Invalid Google access token');

      return tokenInfo;
    } catch (error) {
      this.logger.error('Error verifying Google token:', error);
      throw new UnauthorizedException('Google authentication failed');
    }
  }
}
