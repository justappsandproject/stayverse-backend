import { ApiProperty, ApiPropertyOptional, PartialType, PickType } from "@nestjs/swagger";
import {
  IsEnum,
  IsMongoId,
  IsDate,
  IsOptional,
  ValidateIf,
  IsNotEmpty,
  IsString,
  IsNumber,
  Min,
  IsArray,
} from "class-validator";
import { Type } from "class-transformer";
import { BookingStatus, ServiceType } from "src/common/constants/enum";
import { Types } from "mongoose";
import { PaginationQueryDto } from "src/common/dtos/pagination-query.dto";
export class CreateBookingDto {
  @ApiProperty({
    description: 'The type of service being booked.',
    enum: ServiceType,
  })
  @IsEnum(ServiceType)
  serviceType: ServiceType;

  @ApiPropertyOptional({
    type: [String],
    description: 'Optional list of security-related details for the booking.',
    example: ['24/7 Surveillance', 'Extra locks', 'Private guard']
  })
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  securityDetails?: string[];

  // ---------------- APARTMENT ----------------
  @ApiPropertyOptional()
  @ValidateIf((o) => o.serviceType === ServiceType.APARTMENT)
  @IsMongoId()
  @IsOptional()
  apartmentId?: Types.ObjectId | null;

  @ApiPropertyOptional({
    description: 'End date for apartment booking',
    type: String,
    format: 'date-time',
  })
  @ValidateIf((o) => o.serviceType === ServiceType.APARTMENT)
  @IsDate()
  @Type(() => Date)
  @IsOptional()
  endDate?: Date;

  @ApiPropertyOptional({
    description: 'Google Place ID for pickup location (ride only)',
  })
  @ValidateIf((o) => o.serviceType === ServiceType.RIDE)
  @IsString()
  @IsOptional()
  pickupPlaceId?: string;

  @ApiPropertyOptional()
  @ValidateIf((o) => o.serviceType === ServiceType.RIDE)
  @IsMongoId()
  @IsOptional()
  rideId?: Types.ObjectId | null;

  @ApiPropertyOptional({
    description: 'Total ride hours (required for ride service)',
    example: 4,
  })
  @ValidateIf((o) => o.serviceType === ServiceType.RIDE)
  @IsNumber()
  @Min(1)
  @IsOptional()
  totalHours?: number;

  @ApiProperty({
    description: 'Start date for the booking',
    type: String,
    format: 'date-time',
  })
  @IsDate()
  @Type(() => Date)
  startDate: Date;

  @ApiPropertyOptional({
    description: 'Optional notes or special instructions for the booking.',
    example: 'Please ensure the place is cleaned before arrival.'
  })
  @IsString()
  @IsOptional()
  notes?: string;

}

export class UpdateBookingDto extends PartialType(
  PickType(CreateBookingDto, ['startDate', 'endDate', 'notes'] as const),
) {
  @ApiProperty({
    description: 'Updated start date and time.',
    type: String,
    format: 'date-time',
    required: false,
    example: '2025-06-01T10:00:00.000Z',
  })
  @IsDate()
  @IsOptional()
  @Type(() => Date)
  startDate?: Date;

  @ApiProperty({
    description: 'Updated end date and time.',
    type: String,
    format: 'date-time',
    required: false,
    example: '2025-06-01T18:00:00.000Z',
  })
  @IsDate()
  @IsOptional()
  @Type(() => Date)
  endDate?: Date;

  @ApiPropertyOptional({
    description: 'Optional notes or special instructions for the booking.',
    example: 'Please ensure the place is cleaned before arrival.'
  })
  @IsString()
  @IsOptional()
  notes?: string;
}
export class BookingStatusDto extends PaginationQueryDto {
  @ApiProperty({
    enum: BookingStatus,
    description: 'Filter bookings by status',
    example: BookingStatus.PENDING,
  })
  @IsEnum(BookingStatus)
  status: BookingStatus;
}


export class SearchBookingDto extends PaginationQueryDto {
  @ApiProperty({
    description: 'Search keyword (bookingId, user name, agent name)'
  })
  @IsNotEmpty()
  @IsString()
  keyword: string;
}
