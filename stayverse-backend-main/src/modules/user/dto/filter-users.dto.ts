import { PaginationQueryDto } from "src/common/dtos/pagination-query.dto";
import { ApiPropertyOptional } from "@nestjs/swagger";
import { IsOptional, IsString, IsEnum } from "class-validator";
import { Roles } from "src/common/constants/enum";

export class FilterUsersDto extends PaginationQueryDto {
    @ApiPropertyOptional({
        description: 'Search term to filter users by firstname, lastname, email, or phone number',
        example: 'john'
    })
    @IsOptional()
    @IsString()
    searchTerm?: string;

    @ApiPropertyOptional({
        enum: ['true', 'false'],
        description: 'Filter users by isEmailVerified',
        example: 'true'
    })
    @IsOptional()
    @IsEnum(['true', 'false'])
    isEmailVerified?: string;

    @ApiPropertyOptional({
        enum: Roles,
        description: 'Filter users by role',
        example: 'user'
    })
    @IsOptional()
    @IsEnum(Roles)
    role?: Roles;
} 