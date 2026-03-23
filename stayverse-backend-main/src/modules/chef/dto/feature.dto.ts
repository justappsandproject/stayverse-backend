import { ApiProperty } from '@nestjs/swagger';
import {  IsNotEmpty, IsString } from 'class-validator';

export class CreateFeatureDto {
  @ApiProperty({ type: 'array', items: { type: 'string', format: 'binary' }, description: 'URL of the featured Images' })
  featuredImage: Express.Multer.File[];

  @ApiProperty({
    description: 'JSON stringified array of descriptions for each image (order matters)',
    example: "Chef plating food",
    type: String,
  })
  @IsString()
  @IsNotEmpty()
  imageDescription: string; 
}