import { IsEmail, IsNotEmpty, IsString } from 'class-validator';
import { ApiProperty } from "@nestjs/swagger";

export class VerifyEmailTokenDto {
    @ApiProperty({ example: 'johndoe@gmail.com' })
    @IsEmail()
    @IsNotEmpty()
    email: string;

    @ApiProperty({ example: '102345' })
    @IsString()
    @IsNotEmpty()
    otp: string;
}
