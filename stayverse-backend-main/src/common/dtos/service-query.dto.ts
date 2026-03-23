import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsEnum } from 'class-validator';
import { ServiceStatus } from '../constants/enum';
import { PaginationQueryDto } from './pagination-query.dto';

export class ServiceQueryDto extends PaginationQueryDto {
    @ApiPropertyOptional({
        description: 'Filter by status',
        enum: ServiceStatus,
        example: ServiceStatus.APPROVED,
    })
    @IsOptional()
    @IsEnum(ServiceStatus)
    status?: ServiceStatus;
}
