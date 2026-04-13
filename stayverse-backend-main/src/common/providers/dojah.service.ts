import axios, { AxiosInstance } from "axios";
import { BadRequestException, Injectable, Logger } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { VerifyNinWithSelfieResponse } from "../interfaces/dojah.interface";

@Injectable()
export class DojahService {
  private readonly httpClient: AxiosInstance;
  private readonly logger: Logger;
  private readonly isConfigured: boolean;

  constructor(private readonly configService: ConfigService) {
    const secretKey = this.configService.get<string>('dojah.secretKey');
    const appId = this.configService.get<string>('dojah.apiKey');
    const baseUrl = this.configService.get<string>('dojah.baseUrl') || 'https://sandbox.dojah.io';
    this.logger = new Logger(DojahService.name);

    if (!secretKey || !appId) {
      this.isConfigured = false;
      this.logger.warn('DOJAH not configured. KYC verification will be unavailable until keys are set.');
      return;
    }

    this.isConfigured = true;
    this.httpClient = axios.create({
      baseURL: baseUrl,
      headers: {
        'Authorization': secretKey,
        'AppId': appId,
        'Content-Type': 'application/json',
      },
    });
  }
  async verifyNinWithSelfie(nin: string, selfie: string) {
    if (!this.isConfigured || !this.httpClient) {
      throw new BadRequestException('KYC provider is not configured');
    }
    try {
      const response = await this.httpClient.post('/api/v1/kyc/nin/verify', {
        nin,
        selfie_image: selfie,
      });

      return response.data as VerifyNinWithSelfieResponse;
    } catch (error: any) {
      const status = error.response.status;
      const statusText = error.response.statusText;
      const data = error.response.data.error;

      this.logger.error(
        `NIN verification failed for request. Status: ${status}, StatusText: ${statusText}, Response: ${JSON.stringify(data)}`
      );

      throw new BadRequestException('Invalid NIN');
    }
  }

}
