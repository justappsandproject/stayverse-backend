import { ApiProperty, PartialType } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import { IsArray, IsBoolean, IsDate, IsNotEmpty, IsNumber, IsOptional, IsString, Min } from 'class-validator';
import { BooleanQuestion } from 'src/common/constants/enum';

export class CreateExperienceDto {
    @ApiProperty({ description: 'The Job title', example: 'Caterer' })
    @IsString()
    @IsNotEmpty()
    title: string;

    @ApiProperty({ description: 'The Company Name', example: ' StayChef' })
    @IsString()
    @IsNotEmpty()
    company: string;

    @ApiProperty({ description: 'description', example: 'I was responsible for making pastries' })
    @IsString()
    @IsNotEmpty()
    description: string;

    @ApiProperty({ description: 'startDate', example: '2024-05-01T00:00:00.000Z' })
    @Type(() => Date)
    @IsDate()
    @IsNotEmpty()
    startDate: Date

    @ApiProperty({ description: 'endDate', example: '2024-05-01T00:00:00.000Z' })
    @Type(() => Date)
    @IsDate()
    @IsOptional()    endDate: Date
    
    @ApiProperty({ example: "Lagos, Nigeria" })
    @IsString()
    @IsOptional()
    address: string;

    @ApiProperty({ description: 'Was this job obtained via Stay Verse?', example: false })
    @Transform(({ value }) => value === 'true' || value === true)
    @IsBoolean()
    @IsNotEmpty()
    stayVerseJob: boolean;

}