import { IsString, IsEmail, IsNotEmpty, IsOptional} from 'class-validator';
import { Roles, ServiceType } from '../constants/enum';


export class JwtPayloadDto {
    @IsString()
    @IsNotEmpty()
    sub: string;

    @IsString()
    @IsNotEmpty()
    @IsOptional()
    agent?: string;

    @IsEmail()
    @IsNotEmpty()
    email: string;

    @IsString()
    @IsNotEmpty()
    role: Roles; 

    @IsOptional()
    @IsString()
    serviceType?:ServiceType
}
