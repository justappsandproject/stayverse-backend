import { PipeTransform, Injectable, BadRequestException } from '@nestjs/common';

@Injectable()
export class SecurityPinValidationPipe implements PipeTransform {
    transform(value: string) {
        if (!/^\d{4}$/.test(value)) {
            throw new BadRequestException('Security PIN must be exactly 4 digits.');
        }
        return value;
    }
}
