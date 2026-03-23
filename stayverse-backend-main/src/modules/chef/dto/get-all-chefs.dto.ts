import { PaginationQueryDto } from "src/common/dtos/pagination-query.dto";
import { ServiceStatus } from "src/common/constants/enum";
import { IsEnum, IsOptional } from "class-validator";

export class GetAllChefsDto extends PaginationQueryDto {
    @IsOptional()
    @IsEnum(ServiceStatus)
    status?: ServiceStatus;
}
