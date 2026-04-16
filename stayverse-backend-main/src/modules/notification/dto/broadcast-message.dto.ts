import { IsIn, IsNotEmpty, IsObject, IsOptional, IsString, MaxLength } from 'class-validator';

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
  @IsObject()
  extras?: Record<string, string>;
}
