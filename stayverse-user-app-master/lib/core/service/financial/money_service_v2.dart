/// A utility class for formatting monetary values.
class MoneyServiceV2 {
  /// Formats a double value as a money string with proper thousands separators.
  ///
  /// Parameters:
  /// - [amount]: The monetary amount to format.
  /// - [decimalDigits]: Number of decimal places to show (default: 2).
  /// - [decimalSeparator]: Character to use as decimal separator (default: '.').
  /// - [thousandSeparator]: Character to use as thousand separator (default: ',').
  ///
  /// Returns a formatted string representing the monetary value.
  ///
  /// Example: formatMoney(1234.56) => "1,234.56"
  static String formatMoney(
    double? amount, {
    int decimalDigits = 2,
    String decimalSeparator = '.',
    String thousandSeparator = ',',
  }) {
    // Handle null or negative values
    final value = amount ?? 0.0;

    // Convert to fixed decimal places
    final String valueStr = value.toStringAsFixed(decimalDigits);

    // Split into integer and decimal parts
    final List<String> parts = valueStr.split('.');
    final String integerPart = parts[0];
    final String decimalPart = parts.length > 1 ? parts[1] : '';

    // Add thousand separators to integer part
    final String formattedIntegerPart =
        _addThousandSeparators(integerPart, thousandSeparator);

    // Combine parts
    if (decimalDigits <= 0) {
      return formattedIntegerPart;
    } else {
      return '$formattedIntegerPart$decimalSeparator$decimalPart';
    }
  }

  /// Helper method to add thousand separators to the integer part
  static String _addThousandSeparators(String value, String separator) {
    final buffer = StringBuffer();
    final length = value.length;

    // Handle negative sign
    int startIndex = 0;
    if (value.startsWith('-')) {
      buffer.write('-');
      startIndex = 1;
    }

    // Add digits with separators
    for (int i = startIndex; i < length; i++) {
      buffer.write(value[i]);

      // Add separator after every 3rd digit from the right, except at the end
      if ((length - i - 1) % 3 == 0 && i < length - 1) {
        buffer.write(separator);
      }
    }

    return buffer.toString();
  }

  /// Convenience method for formatting currency with a symbol
  static String formatCurrency(
    double? amount, {
    String symbol = '\$',
    bool symbolOnLeft = true,
    String spaceBetween = '',
    int decimalDigits = 2,
    String decimalSeparator = '.',
    String thousandSeparator = ',',
  }) {
    final formattedAmount = formatMoney(
      amount,
      decimalDigits: decimalDigits,
      decimalSeparator: decimalSeparator,
      thousandSeparator: thousandSeparator,
    );

    return symbolOnLeft
        ? '$symbol$spaceBetween$formattedAmount'
        : '$formattedAmount$spaceBetween$symbol';
  }

  /// Formats an amount specifically for Nigerian Naira (₦)
  ///
  /// Parameters:
  /// - [amount]: The monetary amount to format.
  /// - [includeSymbol]: Whether to include the ₦ symbol (default: true).
  /// - [compactFormat]: If true, uses K, M, B for thousands, millions, billions (default: false).
  /// - [decimalDigits]: Number of decimal places to show (default: 2).
  ///
  /// Examples:
  /// - formatNaira(1234.56) => "₦1,234.56"
  /// - formatNaira(1234567.89, compactFormat: true) => "₦1.23M"
  static String formatNaira(
    double? amount, {
    bool includeSymbol = true,
    bool compactFormat = false,
    int decimalDigits = 2,
  }) {
    final value = amount ?? 0.0;

    if (compactFormat) {
      return _formatCompactNaira(value,
          includeSymbol: includeSymbol, decimalDigits: decimalDigits);
    }

    final formattedAmount = formatMoney(
      value,
      decimalDigits: decimalDigits,
      decimalSeparator: '.',
      thousandSeparator: ',',
    );

    return includeSymbol ? '₦$formattedAmount' : formattedAmount;
  }

  /// Helper method to format Naira in compact notation (K, M, B)
  static String _formatCompactNaira(
    double value, {
    bool includeSymbol = true,
    int decimalDigits = 1,
  }) {
    String symbol = includeSymbol ? '₦' : '';
    String suffix = '';
    double divisor = 1.0;

    if (value.abs() >= 1000000000) {
      suffix = 'B';
      divisor = 1000000000;
    } else if (value.abs() >= 1000000) {
      suffix = 'M';
      divisor = 1000000;
    } else if (value.abs() >= 1000) {
      suffix = 'K';
      divisor = 1000;
    }

    // For small values, use standard formatting
    if (divisor == 1.0) {
      return formatCurrency(
        value,
        symbol: symbol,
        decimalDigits: decimalDigits,
      );
    }

    // Format the divided value
    final compactValue = value / divisor;
    final formattedValue = compactValue.toStringAsFixed(decimalDigits);

    // Remove trailing zeros after decimal point
    final String cleanValue =
        formattedValue.endsWith('.${List.filled(decimalDigits, '0').join()}')
            ? formattedValue.split('.').first
            : formattedValue;

    return '$symbol$cleanValue$suffix';
  }

  /// Formats a double value as Naira with kobo.
  ///
  /// Parameters:
  /// - [amount]: The monetary amount to format.
  /// - [showDecimal]: Whether to show kobo (decimal part) (default: true).
  ///
  /// Examples:
  /// - formatNairaWithKobo(1234.56) => "₦1,234.56"
  /// - formatNairaWithKobo(1234.00, showDecimal: false) => "₦1,234"
  static String formatNairaWithKobo(
    double? amount, {
    bool showDecimal = true,
  }) {
    final value = amount ?? 0.0;
    final bool hasDecimal = (value % 1) != 0;

    // Format with appropriate decimal places
    final int decimalDigits = (showDecimal && hasDecimal) ? 2 : 0;

    return formatNaira(
      value,
      decimalDigits: decimalDigits,
    );
  }

  /// A convenience method that returns just the number without any currency symbol
  /// or with a custom symbol of your choice.
  ///
  /// This replicates the original behavior of the external MoneyFormatter.
  static String formatNairaPlain(
    double? amount, {
    String? customSymbol,
    int decimalDigits = 2,
  }) {
    final value = amount ?? 0.0;
    final String formatted = formatMoney(
      value,
      decimalDigits: decimalDigits,
    );

    return customSymbol != null ? '$customSymbol$formatted' : formatted;
  }

  static double? convertMoneyToDouble(String value) {
    try {
      return double.parse((value).replaceAll(',', ''));
    } on Exception catch (_) {
      return null;
    }
  }

  static bool isBalanceEnough({required double balance, required double amount}) {
    return balance >= amount;
  }
}
