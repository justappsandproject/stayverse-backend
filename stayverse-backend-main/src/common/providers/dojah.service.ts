import axios, { AxiosInstance } from "axios";
import { BadRequestException, Injectable, Logger } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { VerifyNinWithSelfieResponse } from "../interfaces/dojah.interface";

@Injectable()
export class DojahService {
  private readonly httpClient: AxiosInstance;
  private readonly logger: Logger;

  constructor(private readonly configService: ConfigService) {
    const secretKey = this.configService.get<string>('dojah.secretKey');
    const appId = this.configService.get<string>('dojah.apiKey');
    const baseUrl = this.configService.get<string>('dojah.baseUrl') || 'https://sandbox.dojah.io';

    if (!secretKey || !appId) {
      throw new Error('DOJAH_SECRET_KEY and DOJAH_APP_ID are required');
    }

    this.logger = new Logger(DojahService.name);
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
