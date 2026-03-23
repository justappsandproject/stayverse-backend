import { ValidateIf } from "class-validator";

export function IsDefinedAndNotEmpty() {
  return ValidateIf((obj, value) => value !== undefined && value !== '');
}
