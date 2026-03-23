import { ValidatorConstraint, ValidatorConstraintInterface, ValidationArguments} from "class-validator";

@ValidatorConstraint({ name: "CheckInOutValidation", async: false })
export class CheckInOutValidation implements ValidatorConstraintInterface {
    validate(checkIn: Date, args: ValidationArguments) {
        const checkOut = (args.object as any).checkOut;
        if (!checkOut || !checkIn) return false;
        return new Date(checkIn) < new Date(checkOut);
    }

    defaultMessage(args: ValidationArguments) {
        return "Check-out date must be after check-in date";
    }
}
