import { ValidateIf, Min, ValidationOptions, registerDecorator } from 'class-validator';

export function MinIfDefined(minValue: number, validationOptions?: ValidationOptions) {
  return function (object: object, propertyName: string) {
    registerDecorator({
      name: 'MinIfDefined',
      target: object.constructor,
      propertyName,
      options: validationOptions,
      constraints: [minValue],
      validator: {
        validate(value: any) {
          if (value === undefined || value === null || value === '') return true;
          return typeof value === 'number' && value >= minValue;
        },
        defaultMessage() {
          return `${propertyName} must not be less than ${minValue}`;
        },
      },
    });
  };
}
