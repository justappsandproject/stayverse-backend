import { PaginationQueryDto } from "src/common/dtos/pagination-query.dto";
import { ApiPropertyOptional } from "@nestjs/swagger";
import { IsOptional, IsString, IsEnum } from "class-validator";
import { ServiceType } from "src/common/constants/enum";


export class FilterAgentsDto extends PaginationQueryDto {
    @ApiPropertyOptional({
        enum: ServiceType,
        description: 'Filter agents by serviceType',
        example: ServiceType.APARTMENT
    })
    @IsOptional()
    @IsEnum(ServiceType)
    serviceType?: ServiceType;
}