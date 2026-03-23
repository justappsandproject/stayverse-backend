import { ApiProperty, PartialType } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsDate, IsNotEmpty, IsString, Min } from 'class-validator';

export class CreateCertificationDtoo {
    @ApiProperty({ description: 'The title of the Certificate', example: 'Mongodb Associate Developer' })
    @IsString()
    @IsNotEmpty()
    title: string;

    @ApiProperty({ description: 'The organization whom Issued the certificate', example: 'Mongodb' })
    @IsString()
    @IsNotEmpty()
    organization: string

    @ApiProperty({ description: 'Date The certificate was Issued ', example: '2024-05-01T00:00:00.000Z' })
    @Type(() => Date)
    @IsDate()
    @IsNotEmpty()
    issuedDate: Date

    @ApiProperty({ description: 'Certificate Image Link', example: 'https://google.com/mongodb.jpeg' })
    @IsString()
    @IsNotEmpty()
    certificateUrl: string
}
export class UpdateCertificationeDto extends PartialType(CreateCertificationDtoo) { }