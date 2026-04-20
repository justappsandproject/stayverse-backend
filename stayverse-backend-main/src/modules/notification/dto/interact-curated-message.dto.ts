import { IsIn, IsNotEmpty, IsString } from 'class-validator';

export class ReactCuratedMessageDto {
  @IsString()
  @IsNotEmpty()
  @IsIn(['like', 'dislike'])
  reaction: 'like' | 'dislike';
}
