import 'package:dart_extensions/dart_extensions.dart';
import 'package:stayvers_agent/core/service/financial/money_service_v2.dart';
import 'package:stayvers_agent/core/util/app/helper.dart';

///General Class to validate different user eg Password,Email and more
class Validator {
  // Name pattern allows alphabets, spaces, commas, dots, and hyphens
  static const String _namePattern = r'^[a-zA-Z ,.\-]+$';

  // Phone pattern for numbers with optional country code
  static const String _phonePattern = r'(^(?:[+0]9)?[0-9]{10,11}$)';

  // Email pattern for basic email validation
  static const String _emailPattern =
      r'^.+@[a-zA-Z]+\.[a-zA-Z]+(\.[a-zA-Z]+)*$';

  // Password pattern requiring at least one uppercase, one lowercase, and one digit, minimum 6 characters
  static const String _passwordPattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';

  // Full name pattern requiring at least first and last name
  static const String _fullNamePattern = r'^[a-zA-Z]+ [a-zA-Z]+$';

  // BVN pattern for exactly 11 digits
  static const String _bvnPattern = r'^\d{11}$';

  static const String _urlPattern = r'^(https?:\/\/)?' // optional http or https
      r'([a-zA-Z0-9\-]+\.)+[a-zA-Z]{2,}' // domain
      r'(\/[^\s]*)?$'; // optional path

  // Compile the regular expressions
  static final RegExp _nameRegex = RegExp(_namePattern);
  static final RegExp _phoneRegex = RegExp(_phonePattern);
  static final RegExp _emailRegex = RegExp(_emailPattern);
  static final RegExp _passwordRegex = RegExp(_passwordPattern);
  static final RegExp _fullNameRegex = RegExp(_fullNamePattern);
  static final RegExp _bvnRegex = RegExp(_bvnPattern);
  static final RegExp _urlRegex = RegExp(_urlPattern);

  static String? validateEmail(value) {
    if (isEmpty(value)) {
      return 'email is required';
    } else if (!_emailRegex.hasMatch(value)) {
      return 'valid email is required';
    }
    return null;
  }

  static String? validatePhoneNumber(value) {
    if (isEmpty(value) || value!.length == 0) {
      return 'enter phone number';
    }

    if (!_phoneRegex.hasMatch(value)) {
      return 'enter valid phone number';
    }

    // if (value!.length != 11) {
    //   return 'enter valid phone number';
    // }

    return null;
  }

  static String? validateLoginField(value) {
    if (isEmpty(value)) {
      return 'This field is required';
    }
    //if value is integer validate number else validate email
    if (isValueInt(value)) {
      return validatePhoneNumber(value);
    } else {
      return validateEmail(value);
    }
  }

  static String? validateTags(value) {
    if (isEmpty(value)) {
      return null;
    }
    if (value.toString().length > 20) {
      return 'tag is too long';
    }
    return null;
  }

  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (!_fullNameRegex.hasMatch(value.trim())) {
      return 'Enter only first name and a last name';
    }

    return null;
  }

  static String? validateName(value) {
    if (isEmpty(value)) {
      return 'This field is required';
    }

    if (!_nameRegex.hasMatch(value.toString().trim())) {
      return 'Enter valid name';
    }

    return null;
  }

  static String? validateEmptyField(value) {
    if (isEmpty(value)) {
      return 'must not be empty';
    }

    return null;
  }

  static bool isNigeriaAccountNumberValid(String? accountNumber) {
    if (isEmpty(accountNumber)) {
      return false;
    }

    if (accountNumber!.length != 10) {
      return false;
    }
    return true;
  }

  static bool validateBVN(String? value) {
    if (value == null || value.isEmpty || value.length != 11) {
      return false;
    }

    if (!_bvnRegex.hasMatch(value)) {
      return false;
    }

    return true;
  }

  static String? validateNin(value) {
    if (isEmpty(value)) {
      return 'NIN must not be empty';
    }

    if (value.length < 11) {
      return 'NIN must be 11 digits';
    }

    return null;
  }

  static String? validateTitle(value) {
    if (isEmpty(value)) {
      return 'Title must not be empty';
    }

    if (value.length < 10) {
      return 'Title is to short ';
    }

    return null;
  }

  static String? validatePrice(String? value) {
    if (isEmpty(value)) {
      return 'Price Must not be empty';
    }

    String? amount = convertMoneyToString(value);

    if (isEmpty(amount)) {
      return 'Price Must not be empty';
    }

    double amountInDouble = amount!.toDoubleOrNull() ?? 0;

    if (amountInDouble <= 0) {
      return 'Price must be greater that N0';
    }

    return null;
  }

  /// Validates money amount with minimum and maximum allowed limits
  /// [value] - The money value to validate
  /// [minAllowed] - Minimum allowed amount (default: 0)
  /// [maxAllowed] - Maximum allowed amount (default: double.infinity)
  /// [currencySymbol] - Currency symbol for error messages (default: 'N')
  static String? validateMoney(
    String? value, {
    double minAllowed = 0,
    double maxAllowed = double.infinity,
  }) {
    if (isEmpty(value)) {
      return 'Amount must not be empty';
    }

    String? amount = convertMoneyToString(value);

    if (isEmpty(amount)) {
      return 'Amount must not be empty';
    }

    double amountInDouble = amount!.toDoubleOrNull() ?? 0;

    if (amountInDouble < 0) {
      return 'Amount cannot be negative';
    }

    if (amountInDouble < minAllowed) {
      return 'Amount must be at least ${MoneyServiceV2.formatNaira(minAllowed)}';
    }

    if (amountInDouble > maxAllowed) {
      return 'Amount cannot exceed ${MoneyServiceV2.formatNaira(maxAllowed)}';
    }

    return null;
  }

  static String? validateDesc(value) {
    if (isEmpty(value)) {
      return 'Description must not be empty';
    }

    if (value.length < 11) {
      return 'Description is to short ';
    }

    return null;
  }

  static String? validateAddress(value) {
    if (isEmpty(value)) {
      return 'Address must not be empty';
    }

    if (value.length < 11) {
      return 'Address is to short';
    }

    return null;
  }

  static String? validatePassword(value) {
    if (isEmpty(value)) {
      return 'Please enter your password';
    }

    if (value.toString().trim().length < 6) {
      return 'Password Must be greater than 6';
    }

    if (!_passwordRegex.hasMatch(value.toString().trim())) {
      return 'Password must contain capital letter,number';
    }

    return null;
  }

  static String? validateConfirmPassword(confirmPassword, password) {
    if (validatePassword(password) != null) {
      return null;
    }

    if (validatePassword(confirmPassword) != null) {
      return validatePassword(confirmPassword);
    }

    if (confirmPassword.toString().trim() != password.toString().trim()) {
      return 'Password does not match';
    }

    return null;
  }

  ///Add country code to the number
  static String? formatNumber(String? number) {
    if (isEmpty(number)) {
      return null;
    }
    if (number!.length < 11) {
      return null;
    }

    if (number.startsWith('0')) {
      return number.replaceFirst('0', '+234');
    }

    return null;
  }

  static String? validatePin(String? value, {int validLength = 6}) {
    if (isEmpty(value)) {
      return 'Must not be empty';
    }

    if (value!.length != validLength) {
      return 'Otp Code must be $validLength digits';
    }

    return null;
  }

  static String? validateConfirmPin(String? confirmPin, String? pin,
      {int validLength = 6}) {
    if (validatePin(pin, validLength: validLength) != null) {
      return validatePin(pin, validLength: validLength);
    }

    if (validatePin(confirmPin, validLength: validLength) != null) {
      return validatePin(confirmPin, validLength: validLength);
    }

    if (confirmPin.toString().trim() != pin.toString().trim()) {
      return 'Pin does not match';
    }

    return null;
  }

  ///Validate for pin [6 is a default pin for [venpay]
  static bool isPinValid(int pinLength, {int validLength = 6}) {
    return (validLength == pinLength);
  }

  static String? validateUrl(String? value) {
    if (isEmpty(value)) {
      return 'URL is required';
    }

    if (!_urlRegex.hasMatch(value!)) {
      return 'Enter a valid URL';
    }

    return null;
  }

  static String? validateAccountNumber(String? accountNumber) {
    if (isEmpty(accountNumber)) {
      return 'Must not be empty';
    }

    if (accountNumber!.length != 10) {
      return 'Enter a valid account number';
    }
    return null;
  }
}
