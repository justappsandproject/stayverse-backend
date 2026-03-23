import { ApiProperty } from "@nestjs/swagger";
import { IsDateString, IsEnum, IsOptional, IsString } from "class-validator";
import { BookingStatus, ServiceType } from "src/common/constants/enum";
import { PaginationQueryDto } from "src/common/dtos/pagination-query.dto";

export class GetAdminBookingsDto extends PaginationQueryDto {
    @IsOptional()
    @IsString()
    @ApiProperty({ type: String, format: 'ObjectId', required: false })
    agentId?: string;

    @IsOptional()
    @IsEnum(ServiceType)
    @ApiProperty({ enum: ServiceType, required: false })
    serviceType?: ServiceType;

    @IsOptional()
    @IsEnum(BookingStatus)
    @ApiProperty({ enum: BookingStatus, required: false })
    status?: BookingStatus;

    @IsOptional()
    @IsString()
    @IsDateString()
    @ApiProperty({ type: String, format: 'date-time', required: false })
    startDate?: string;

    @IsOptional()
    @IsString()
    @IsDateString()
    @ApiProperty({ type: String, format: 'date-time', required: false })
    endDate?: string;
}