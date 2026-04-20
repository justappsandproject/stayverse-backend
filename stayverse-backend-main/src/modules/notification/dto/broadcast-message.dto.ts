import {
  IsDateString,
  IsIn,
  IsNotEmpty,
  IsObject,
  IsOptional,
  IsString,
  IsUrl,
  MaxLength,
} from 'class-validator';

export class BroadcastMessageDto {
  @IsString()
  @IsIn(['user', 'agent', 'all'])
  audience: 'user' | 'agent' | 'all';

  @IsString()
  @IsNotEmpty()
  @MaxLength(100)
  title: string;

  @IsString()
  @IsNotEmpty()
  @MaxLength(500)
  body: string;

  @IsOptional()
  @IsString()
  @IsUrl({ require_tld: false }, { message: 'imageUrl must be a valid URL' })
  imageUrl?: string;

  @IsOptional()
  @IsString()
  @IsIn(['before', 'after'])
  imagePosition?: 'before' | 'after';

  @IsOptional()
  @IsString()
  @IsIn(['now', 'scheduled'])
  sendMode?: 'now' | 'scheduled';

  @IsOptional()
  @IsDateString()
  scheduledAt?: string;

  @IsOptional()
  @IsObject()
  extras?: Record<string, string>;
}
