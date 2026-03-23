import {
  Controller,
  Post,
  Body,
  Param,
  UseGuards,
  Req,
  Query,
  Get,
  Res,
  Patch,
  Logger,
} from '@nestjs/common';
import { PaymentsService } from '../service/payments.service';
import {
  FilterEscrowDto,
  FilterTransactionsDto,
  FundWalletDto,
  RequestWithdrawalDto,
  ResolveBankAccountDto,
  UpdateAdminEscrowStatusDto
} from '../dto/payments.dto';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiBody,
  ApiParam,
} from '@nestjs/swagger';
import { AuthGuard, Public } from 'src/common/guards/auth.guard';
import { AuthenticatedRequest } from 'src/common/types/app.interface';
import { Role, RolesGuard } from 'src/common/guards/roles.guard';
import { Roles } from 'src/common/constants/enum';
import { Request, Response } from 'express';
import { PaystackWebhookService } from '../service/paystack-webhook.service';

@ApiTags('Payments')
@ApiBearerAuth()
@Controller('payments')
@UseGuards(AuthGuard, RolesGuard)
export class PaymentsController {
  private readonly logger = new Logger(PaymentsController.name);

  constructor(private readonly paymentsService: PaymentsService,
    private readonly webhookService: PaystackWebhookService
  ) { }

  @Post('fund-wallet')
  @ApiOperation({ summary: 'Fund user wallet via Paystack' })
  @ApiResponse({ status: 201, description: 'Transaction initialized successfully' })
  @ApiResponse({ status: 400, description: 'Invalid request' })
  @ApiBody({ type: FundWalletDto })
  async fundWallet(@Req() req, @Body() dto: FundWalletDto) {
    const userId = req.user.sub;
    return this.paymentsService.fundWallet(userId, dto.amount);
  }

  @Post('verify/:reference')
  @ApiOperation({ summary: 'Verify wallet funding transaction' })
  @ApiResponse({ status: 200, description: 'Payment verified successfully' })
  @ApiResponse({ status: 400, description: 'Payment verification failed' })
  async verifyPayment(@Param('reference') reference: string) {
    return this.paymentsService.verifyPayment(reference);
  }

  @Post('withdraw')
  @ApiOperation({ summary: 'Request withdrawal for agent or user' })
  @ApiResponse({ status: 201, description: 'Withdrawal initiated successfully' })
  @ApiResponse({ status: 400, description: 'Insufficient balance or invalid request' })
  @ApiBody({ type: RequestWithdrawalDto })
  async requestWithdrawal(@Body() dto: RequestWithdrawalDto, @Req() req: AuthenticatedRequest) {
    const userId = req.user.sub;
    return this.paymentsService.requestWithdrawal(userId, dto);
  }

  @Get('banks')
  @ApiOperation({ summary: 'Get list of banks for a country' })
  @ApiResponse({ status: 200, description: 'List of banks' })
  async getBanks() {
    return this.paymentsService.getBanks();
  }

  @Post('resolve-account')
  @ApiOperation({ summary: 'Resolve bank account number to account name' })
  async resolveBankAccount(@Body() dto: ResolveBankAccountDto) {
    return this.paymentsService.resolveBankAccount(dto);
  }

  @Post('webhook')
  @Public()
  @ApiOperation({ summary: 'Webhook handler for Paystack payments' })
  async handleWebhook(@Req() req: Request, @Res() res: Response) {
    try {
      this.webhookService.validateWebhookEvent(req);

      const event = req.body?.event;
      const data = req.body?.data;

      if (!event || !data) throw new Error('Invalid webhook payload');

      this.logger.log(`Paystack webhook received: ${event} | ref=${data.reference || data.transfer_code || 'N/A'}`);

      switch (event) {
        case 'charge.success':
          await this.webhookService.handleChargeSuccess(data);
          break;
        case 'transfer.success':
          await this.webhookService.handleTransferSuccess(data);
          break;
        case 'transfer.failed':
          await this.webhookService.handleTransferFailed(data);
          break;
        case 'transfer.reversed':
          await this.webhookService.handleTransferReversed(data);
          break;
        default:
          this.logger.warn(`Unhandled Paystack event: ${event}`);
          break;
      }
      res.sendStatus(200);
    } catch (error) {
      this.logger.error(`Webhook processing error: ${error.message}`, error.stack);
      res.sendStatus(400);
    }
  }

  @Get()
  @ApiOperation({ summary: 'Get all transactions (paginated, filterable)' })
  async getAllTransactions(
    @Query() query: FilterTransactionsDto,
    @Req() req: AuthenticatedRequest
  ) {
    const userId = req.user.agent ?? req.user.sub;

    return this.paymentsService.getAllTransactions(query, userId);
  }

  @Get('/admin')
  @Role(Roles.ADMIN)
  @ApiOperation({ summary: 'Get all transactions (paginated, filterable) or admin' })
  async getAllAdminTransactions(
    @Query() query: FilterTransactionsDto,
  ) {
    return this.paymentsService.getAllTransactions(query);
  }

  @Get('/escrow')
  @Role(Roles.ADMIN)
  @ApiOperation({ summary: 'Get all payment escrows (admin only, paginated)' })
  @ApiResponse({ status: 200, description: 'List of all escrows retrieved successfully' })
  async getAllEscrows(@Query() query: FilterEscrowDto) {
    return this.paymentsService.getAllEscrows(query);
  }

  @Patch('/escrow/:id/status')
  @Role(Roles.ADMIN)
  @ApiOperation({ summary: 'Update the admin escrow status' })
  @ApiParam({ name: 'id', description: 'Escrow ID', type: String })
  @ApiResponse({ status: 200, description: 'Escrow status updated successfully' })
  @ApiResponse({ status: 404, description: 'Escrow not found' })
  async updateEscrowStatus(
    @Param('id') escrowId: string,
    @Body() dto: UpdateAdminEscrowStatusDto,
  ) {
    return this.paymentsService.updateEscrowStatus(escrowId, dto);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get a single transaction by ID' })
  @ApiParam({ name: 'id', description: 'Transaction ID', type: String })
  async getTransactionById(@Param('id') id: string) {
    return this.paymentsService.getTransactionById(id);
  }
}
