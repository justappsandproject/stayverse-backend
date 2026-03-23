import { IsEmail, IsEnum, IsNotEmpty, IsNumber, IsOptional, IsPositive, IsString, IsUUID, Length } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { PaginationQueryDto } from 'src/common/dtos/pagination-query.dto';
import { AdminEscrowStatus, EscrowStatus, PayoutType } from 'src/common/constants/enum';

export class FundWalletDto {
    @ApiProperty({
        description: 'The amount to fund the wallet (in Naira)',
        example: 5000,
    })
    @IsNumber()
    amount: number;
}

export class HoldEscrowDto {
    @ApiProperty({
        description: 'The ID of the booking associated with the escrow',
        example: '64ebf1a2c1234567890abcd1',
    })
    @IsString()
    @IsNotEmpty()
    bookingId: string;

    @ApiProperty({
        description: 'The ID of the mentor for whom the escrow is held',
        example: '64ebf1a2c1234567890abcd2',
    })
    @IsString()
    @IsNotEmpty()
    mentorId: string;

    @ApiProperty({
        description: 'The amount to be held in escrow (in Naira)',
        example: 3000,
    })
    @IsNumber()
    amount: number;
}
export class UserToMentorTransferDto {
    @ApiProperty({
        description: 'The booking ID associated with the transfer',
        example: '64f9b2c9e6c8b6f1a4d2e3b7',
    })
    @IsString()
    @IsNotEmpty()
    bookingId: string;
}
export class ResolveBankAccountDto {
    @ApiProperty({ description: 'Bank account number', example: '0123456789' })
    @IsNotEmpty()
    @IsString()
    @Length(10, 10, { message: 'Account number must be 10 digits' })
    account_number: string;

    @ApiProperty({ description: 'Bank code', example: '058' })
    @IsNotEmpty()
    @IsString()
    bank_code: string;
}
export class FilterTransactionsDto extends PaginationQueryDto {
  @IsOptional()
  @IsString()
  searchTerm?: string;

  @IsOptional()
  @IsEnum(['pending', 'successful', 'failed'], {
    message: 'status must be one of: pending, successful, failed',
  })
  status?: string;

  @IsOptional()
  @IsEnum(['credit', 'debit'], {
    message: 'type must be one of: credit, debit',
  })
  type?: string;
}

export class RequestWithdrawalDto {
    @ApiProperty({
        description: 'Full name of the account holder',
        example: 'John Doe',
    })
    @IsString()
    @IsNotEmpty()
    fullName: string;

    @ApiProperty({
        description: 'Bank account number of the recipient',
        example: '0100000000',
    })
    @IsString()
    @IsNotEmpty()
    accountNumber: string;

    @ApiProperty({
        description: 'Bank code of the recipient\'s bank',
        example: '044',
    })
    @IsString()
    @IsNotEmpty()
    bankCode: string;

    @ApiProperty({ example: 5000, description: 'Withdrawal amount in NGN' })
    @IsNumber()
    @IsPositive()
    amount: number;

    @ApiProperty({ example: 'StrongPassword123@', description: 'User account password for verification' })
    @IsString()
    password: string
}

export class FinalizeWithdrawalDto {
    @ApiProperty({
        description: 'The transfer code returned by Paystack when initiating withdrawal',
        example: 'TRF_kd92jd92jd92',
    })
    @IsString()
    transfer_code: string;

    @ApiProperty({
        description: 'The OTP sent by Paystack to finalize the withdrawal',
        example: '123456',
    })
    @IsString()
    otp: string;
}

export class FilterEscrowDto extends PaginationQueryDto {
  @ApiPropertyOptional({ enum: EscrowStatus, description: 'Filter by escrow status' })
  @IsOptional()
  @IsEnum(EscrowStatus)
  status?: EscrowStatus;

  @ApiPropertyOptional({ enum: PayoutType, description: 'Filter by payout type' })
  @IsOptional()
  @IsEnum(PayoutType)
  payoutType?: PayoutType;

  @ApiPropertyOptional({ enum: AdminEscrowStatus, description: 'Filter by admin escrow status' })
  @IsOptional()
  @IsEnum(AdminEscrowStatus)
  adminEscrowStatus?: AdminEscrowStatus;

  @ApiPropertyOptional({ description: 'Search term (reference or description)' })
  @IsOptional()
  @IsString()
  searchTerm?: string;
}

export class UpdateAdminEscrowStatusDto {
  @ApiProperty({
    description: 'The new status of the escrow',
    enum: AdminEscrowStatus,
    example: AdminEscrowStatus.RELEASED,
  })
  @IsEnum(AdminEscrowStatus)
  status: AdminEscrowStatus;
}