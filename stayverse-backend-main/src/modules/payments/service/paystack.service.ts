import {
  Injectable,
  InternalServerErrorException,
  BadRequestException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Paystack } from 'paystack-sdk';
import axios from 'axios';

@Injectable()
export class PaystackService {
  private readonly paystack: Paystack;
  private readonly paystackSecret: string;

  constructor(private readonly config: ConfigService) {
    this.paystackSecret = this.config.get<string>('paystack.secretKey');
    this.paystack = new Paystack(this.paystackSecret);
  }

  async getBankList() {
    try {
      const url = 'https://api.paystack.co/bank';
      const result = await axios.get(url, {
        headers: { Authorization: `Bearer ${this.paystackSecret}` },
      });

      if (result.data?.status === true && Array.isArray(result.data?.data)) {
        return result.data.data; // return the bank list
      }

      return false; // if Paystack did not return as expected
    } catch (error: any) {
      console.error('Paystack getBankList Error:', error.response?.data || error.message);
      return false;
    }
  }

  async createCustomer(params: {
    first_name: string;
    last_name: string;
    email: string;
    phone?: string;
  }): Promise<any> {
    try {
      const response = await this.paystack.customer.create(params);
      if (!response.status) throw new Error(response.message || 'Paystack API Error');
      return response.data;
    } catch (error: any) {
      console.error('Paystack createCustomer Error:', error.response?.data || error.message);
      throw new InternalServerErrorException(
        error.response?.data?.message || 'Unable to create customer',
      );
    }
  }

  async initializeTransaction(data: {
    email: string;
    amount: number | string;
    customer: string;
  }): Promise<any> {
    try {
      const payload = {
        ...data,
        amount: typeof data.amount === 'number' ? (data.amount).toString() : data.amount,
        callback_url: this.config.get<string>('paystack.callbackUrl'),
      };

      const response = await this.paystack.transaction.initialize(payload);

      if (!response.status) throw new Error(response.message || 'Paystack API Error');

      return response.data;
    } catch (error: any) {
      console.error(
        'Paystack initializeTransaction Error:',
        error.response?.data || error.message,
      );
      throw new InternalServerErrorException(
        error.response?.data?.message || 'Unable to initialize transaction',
      );
    }
  }

  async verifyTransaction(reference: string): Promise<any> {
    if (!reference) throw new BadRequestException('Transaction reference is required');

    try {
      const response = await this.paystack.transaction.verify(reference);
      if (!response.status) throw new Error(response.message || 'Paystack API Error');
      return response;
    } catch (error: any) {
      console.error('Paystack verifyTransaction Error:', error.response?.data || error.message);

      if (error.response?.data?.message?.toLowerCase().includes('invalid')) {
        throw new BadRequestException('Invalid transaction reference');
      }

      throw new InternalServerErrorException(
        error.response?.data?.message || 'Unable to verify transaction',
      );
    }
  }

  async resolveAccount({ account_number, bank_code }: { account_number: string, bank_code: string }) {
    const result = await this.paystack.verification.resolveAccount({ account_number, bank_code });

    if (!result.status || !result.data?.account_number) {
      throw new BadRequestException('Invalid Account. Please check the account information and try again.');
    }

    return result.data;
  }
  async createTransferRecipient(params: {
    type: 'nuban'
    name: string
    account_number: string
    bank_code: string
  }): Promise<any> {
    try {
      const response = await this.paystack.recipient.create(params)
      if (!response.status) return false
      return response.data
    } catch (error) {
      console.error('Paystack createTransferRecipient Error:', error)
      throw error
    }
  }

  async initiateTransfer(data: {
    recipient: string;
    amount: number;
    reason?: string;
    source: 'balance';
  }): Promise<any> {
    try {
      const response = await this.paystack.transfer.initiate(data);

      // Check if response is successful
      if (!response.status) {
        throw new Error(response.message || 'Paystack API Error');
      }

      return (response as { data: any }).data;
    } catch (error: any) {
      console.error(
        'Paystack initiateTransfer Error:',
        error.response?.data || error.message,
      );
      throw new InternalServerErrorException(
        error.response?.data?.message || 'Unable to initiate transfer',
      );
    }
  }
}
