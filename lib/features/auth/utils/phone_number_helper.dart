import '../models/country_code.dart';

class PhoneNumberHelper {
  /// Validates the phone number based on its length
  static bool isValidPhoneNumber(String phoneNumber, CountryCode countryCode) {
    // Remove any non-digit characters
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Basic validation based on common phone number lengths (adjust as needed)
    switch (countryCode.code) {
      case 'US':
      case 'CA':
        return cleanNumber.length == 10;
      case 'IN':
        return cleanNumber.length == 10;
      case 'GB':
        return cleanNumber.length >= 10 && cleanNumber.length <= 11;
      case 'AU':
        return cleanNumber.length == 9 || cleanNumber.length == 10;
      default:
        // Most countries have phone numbers between 8 and 12 digits
        return cleanNumber.length >= 8 && cleanNumber.length <= 12;
    }
  }

  /// Formats the phone number to E.164 format
  static String formatToE164(String phoneNumber, CountryCode countryCode) {
    // Remove any non-digit characters
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Format to E.164
    return '${countryCode.dialCode}$cleanNumber';
  }

  /// Returns an error message if the phone number is invalid, null otherwise
  static String? getValidationError(
    String phoneNumber,
    CountryCode countryCode,
  ) {
    if (phoneNumber.isEmpty) {
      return 'Phone number is required';
    }

    final cleanNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    if (!isValidPhoneNumber(cleanNumber, countryCode)) {
      return 'Please enter a valid phone number for ${countryCode.name}';
    }

    return null;
  }
}
