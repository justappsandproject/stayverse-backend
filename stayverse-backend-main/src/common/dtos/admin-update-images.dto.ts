import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString } from 'class-validator';

export class AdminUpdateGalleryImagesDto {
  @ApiPropertyOptional({
    description: 'JSON array of existing image URLs to keep (order preserved)',
    example: '["https://cdn.example.com/stayVerse/apartments/a.jpg"]',
  })
  @IsOptional()
  @IsString()
  keepImages?: string;
}
