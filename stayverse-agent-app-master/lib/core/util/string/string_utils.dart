class StringUtils {
  static String printMap(Map<String, dynamic>? map) {
    String str = '';
    map?.forEach((key, value) => str += '$key: ${value.toString}, ');
    return str;
  }

  static String capitalize(String value) {
    return '${value[0].toUpperCase()}${value.substring(1).toLowerCase()}';
  }

  static String formatPhoneNumber(String phoneNumber) {
   
    if (phoneNumber.length == 10) {
      return '0$phoneNumber';
    }

    // Return the phone number as is if it has 11 digits
    return phoneNumber;
  }
}
