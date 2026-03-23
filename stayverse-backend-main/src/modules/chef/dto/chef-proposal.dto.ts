import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";
import { IsDateString, IsEnum, IsMongoId, IsNumber, IsOptional, IsString, Min } from "class-validator";
import { ProposalStatus } from "src/common/constants/enum";
import { PaginationQueryDto } from "src/common/dtos/pagination-query.dto";

export class CreateChefProposalDto {
  @ApiProperty({
    description: 'The price quoted by the chef',
    example: 150.0,
  })
  @IsNumber()
  @Min(0)
  price: number;

  @ApiProperty({
    description: 'Description of the proposal, including details of the service',
    example: 'I will prepare a 3-course Italian dinner at your home with wine pairing.',
  })
  @IsString()
  description: string;

  @ApiProperty({
    description: 'Date the chef is proposing to provide the service',
    example: '2025-11-10T18:00:00Z',
  })
  @IsDateString()
  date: string;
}


export class RespondChefProposalDto {
  @ApiProperty({
    description: 'The status of the proposal after user response',
    enum: ProposalStatus,
    example: ProposalStatus.ACCEPTED,
  })
  @IsEnum(ProposalStatus)
  status: ProposalStatus;
}

export class GetProposalsQueryDto extends PaginationQueryDto {
  @ApiPropertyOptional({
    enum: ProposalStatus,
    description: 'Filter proposals by status (e.g. PENDING, ACCEPTED, REJECTED)',
  })
  @IsEnum(ProposalStatus)
  @IsOptional()
  status?: ProposalStatus;
}