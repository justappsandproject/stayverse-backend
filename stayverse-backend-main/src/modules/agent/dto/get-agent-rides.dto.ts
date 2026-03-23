import { PaginationQueryDto } from 'src/common/dtos/pagination-query.dto';
import { ServiceStatus } from 'src/common/constants/enum';
import { IsEnum, IsOptional } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class GetAgentRidesDto extends PaginationQueryDto {
  @IsOptional()
  @IsEnum(ServiceStatus)
  @ApiProperty({ enum: ServiceStatus, required: false })
  status?: ServiceStatus;
}
