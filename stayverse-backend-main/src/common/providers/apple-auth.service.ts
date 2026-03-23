import { Injectable, UnauthorizedException, Logger } from '@nestjs/common';
import * as jwt from 'jsonwebtoken';
import axios from 'axios';
import jwksClient from 'jwks-rsa';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class AppleAuthService {
  private readonly logger = new Logger(AppleAuthService.name);
  private appleClientId: string;
  private appleIssuer: string;
  private jwks: jwksClient.JwksClient;

  constructor(private readonly configService: ConfigService) {
    this.appleClientId = this.configService.get<string>('apple.clientId'); // your Apple Service ID
    this.appleIssuer = 'https://appleid.apple.com';
    this.jwks = jwksClient({
      jwksUri: 'https://appleid.apple.com/auth/keys',
    });
  }

  private getKey(header: jwt.JwtHeader, callback: jwt.SigningKeyCallback) {
    this.jwks.getSigningKey(header.kid, (err, key) => {
      if (err) {
        callback(err, undefined);
      } else {
        const signingKey = key?.getPublicKey();
        callback(null, signingKey);
      }
    });
  }

  async verifyIdToken(idToken: string) {
    try {
      const decoded: any = jwt.verify(idToken, this.getKey.bind(this), {
        audience: this.appleClientId,
        issuer: this.appleIssuer,
      });

      if (!decoded.email) throw new UnauthorizedException('Invalid Apple ID token');
      return decoded; // includes email, sub (user ID), and other claims
    } catch (error) {
      this.logger.error('Error verifying Apple ID token:', error);
      throw new UnauthorizedException('Apple authentication failed');
    }
  }

  // Optional: validate authorizationCode with Apple server for server-side login
  async getAccessToken(authorizationCode: string) {
    const clientId = this.appleClientId;
    const clientSecret = this.configService.get<string>('apple.clientSecret'); // generated JWT for Apple
    const tokenEndpoint = 'https://appleid.apple.com/auth/token';

    try {
      const response = await axios.post(
        tokenEndpoint,
        new URLSearchParams({
          client_id: clientId,
          client_secret: clientSecret,
          code: authorizationCode,
          grant_type: 'authorization_code',
        }),
        { headers: { 'Content-Type': 'application/x-www-form-urlencoded' } }
      );

      return response.data; // contains id_token, access_token, refresh_token
    } catch (error) {
      this.logger.error('Error fetching Apple access token:', error.response?.data || error);
      throw new UnauthorizedException('Apple token exchange failed');
    }
  }
}
