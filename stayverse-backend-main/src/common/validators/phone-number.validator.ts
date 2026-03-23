import { registerDecorator, ValidationOptions, ValidatorConstraint, ValidatorConstraintInterface } from 'class-validator';
import { parsePhoneNumberFromString } from 'libphonenumber-js';

// Validator Constraint for Phone Number
@ValidatorConstraint({ async: false })
export class IsPhoneNumberConstraint implements ValidatorConstraintInterface {
    validate(phoneNumber: any) {
        const phone = parsePhoneNumberFromString(phoneNumber, 'NG'); // Change 'NG' to your default country code
        return phone?.isValid() || false;
    }

    defaultMessage() {
        return 'Invalid phone number';
    }
}

// Custom Decorator for Phone Number Validation
export function IsPhoneNumber(validationOptions?: ValidationOptions) {
    return function (object: object, propertyName: string) {
        registerDecorator({
            target: object.constructor,
            propertyName: propertyName,
            options: validationOptions,
            constraints: [],
            validator: IsPhoneNumberConstraint,
        });
    };
}
