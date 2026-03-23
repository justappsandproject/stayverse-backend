
import { PipeTransform, Injectable, BadRequestException } from '@nestjs/common';
import { parsePhoneNumberFromString } from 'libphonenumber-js';

@Injectable()
export class ParsePhoneNumberPipe implements PipeTransform {
    transform(value: any): any {
        const phoneNumber = parsePhoneNumberFromString(value, 'NG'); // Replace 'NG' with your default country code

        if (!phoneNumber || !phoneNumber.isValid()) {
            throw new BadRequestException('Invalid phone number');
        }

        return phoneNumber.number; // Return the number in E.164 international format
    }
}
