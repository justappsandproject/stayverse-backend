import { PickType, ApiProperty } from '@nestjs/swagger';
import { IsEnum, IsMongoId, IsNotEmpty, IsOptional, ValidateIf } from 'class-validator';
import { Types } from 'mongoose';
import { FavoriteStatus, ServiceType } from 'src/common/constants/enum';
import { PaginationQueryDto } from 'src/common/dtos/pagination-query.dto';

export class CreateFavoriteDto {
  @ApiProperty({
    description: 'ID of the apartment (if applicable).',
    type: String,
    required: false,
    nullable: true,
    example: '60d0fe4f5311236168a109cc',
  })
  @ValidateIf(o => o.apartmentId !== null && o.apartmentId !== undefined)
  @IsMongoId()
  @IsOptional()
  apartmentId?: Types.ObjectId | null;

  @ApiProperty({
    description: 'ID of the ride (if applicable).',
    type: String,
    required: false,
    nullable: true,
    example: '60d0fe4f5311236168a109cd',
  })
  @ValidateIf(o => o.rideId !== null && o.rideId !== undefined)
  @IsMongoId()
  @IsOptional()
  rideId?: Types.ObjectId | null;

  @ApiProperty({
    description: 'ID of the Chef (if applicable).',
    type: String,
    required: false,
    nullable: true,
    example: '60d0fe4f5311236168a109cd',
  })
  @ValidateIf(o => o.rideId !== null && o.rideId !== undefined)
  @IsMongoId()
  @IsOptional()
  chefId?: Types.ObjectId | null;


  @ApiProperty({
    enum: ServiceType,
    example: ServiceType.APARTMENT,
    description: 'The type of service being favorited',
  })
  @IsEnum(ServiceType)
  @IsNotEmpty()
  serviceType: ServiceType;
}
export class FavoriteQueryDto extends PaginationQueryDto{
   @ApiProperty({
    enum: ServiceType,
    example: ServiceType.APARTMENT,
    description: 'The type of service being favorited',
  })
  @IsEnum(ServiceType)
  @IsNotEmpty()
  serviceType: ServiceType;
}