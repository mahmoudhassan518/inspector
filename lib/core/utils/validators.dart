/// Common validation utilities
/// 
/// Provides static methods for common validation patterns.
/// Use these with [FieldValidator] rules or Flutter's [TextFormField] validator.
/// 
/// Usage with FieldValidator:
/// ```dart
/// FieldValidator<String>(
///   value: email,
///   rules: [
///     ((v) => Validators.isEmpty(v), 'Email is required'),
///     ((v) => !Validators.isValidEmail(v), 'Invalid email'),
///   ],
/// );
/// ```
/// 
/// Usage with TextFormField:
/// ```dart
/// TextFormField(
///   validator: Validators.required('Email is required'),
/// )
/// ```
class Validators {
  Validators._();
  
  // ============================================================
  // String Validators
  // ============================================================
  
  /// Check if string is null or empty
  static bool isEmpty(String? value) => value == null || value.isEmpty;
  
  /// Check if string is null, empty, or whitespace only
  static bool isBlank(String? value) => value == null || value.trim().isEmpty;
  
  /// Check if string is not null and not empty
  static bool isNotEmpty(String? value) => value != null && value.isNotEmpty;
  
  /// Check if string is not null and has non-whitespace content
  static bool isNotBlank(String? value) => value != null && value.trim().isNotEmpty;
  
  /// Check if string length is at least [minLength]
  static bool hasMinLength(String? value, int minLength) =>
      value != null && value.length >= minLength;
  
  /// Check if string length is at most [maxLength]
  static bool hasMaxLength(String? value, int maxLength) =>
      value == null || value.length <= maxLength;
  
  /// Check if string length is between [min] and [max] (inclusive)
  static bool hasLengthBetween(String? value, int min, int max) =>
      value != null && value.length >= min && value.length <= max;
  
  // ============================================================
  // Pattern Validators
  // ============================================================
  
  /// Email regex pattern
  static final _emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  
  /// Phone regex pattern (international format)
  static final _phonePattern = RegExp(
    r'^\+?[1-9]\d{1,14}$',
  );
  
  /// Saudi phone number pattern
  static final _saudiPhonePattern = RegExp(
    r'^(05|5)[0-9]{8}$',
  );
  
  /// URL pattern
  static final _urlPattern = RegExp(
    r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    caseSensitive: false,
  );
  
  /// Check if string is a valid email
  static bool isValidEmail(String? value) =>
      value != null && _emailPattern.hasMatch(value.trim());
  
  /// Check if string is a valid phone number (international)
  static bool isValidPhone(String? value) =>
      value != null && _phonePattern.hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  
  /// Check if string is a valid Saudi phone number
  static bool isValidSaudiPhone(String? value) {
    if (value == null) return false;
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    // Remove +966 or 966 prefix if present
    final normalized = cleaned.replaceFirst(RegExp(r'^(\+966|966)'), '');
    return _saudiPhonePattern.hasMatch(normalized);
  }
  
  /// Check if string is a valid URL
  static bool isValidUrl(String? value) =>
      value != null && _urlPattern.hasMatch(value.trim());
  
  /// Check if string matches a regex pattern
  static bool matchesPattern(String? value, RegExp pattern) =>
      value != null && pattern.hasMatch(value);
  
  // ============================================================
  // Number Validators
  // ============================================================
  
  /// Check if string is a valid number
  static bool isNumeric(String? value) =>
      value != null && double.tryParse(value) != null;
  
  /// Check if number is within range (inclusive)
  static bool isInRange(num? value, num min, num max) =>
      value != null && value >= min && value <= max;
  
  /// Check if value is greater than [min]
  static bool isGreaterThan(num? value, num min) =>
      value != null && value > min;
  
  /// Check if value is less than [max]
  static bool isLessThan(num? value, num max) =>
      value != null && value < max;
  
  /// Check if value is positive (> 0)
  static bool isPositive(num? value) =>
      value != null && value > 0;
  
  /// Check if value is non-negative (>= 0)
  static bool isNonNegative(num? value) =>
      value != null && value >= 0;
  
  // ============================================================
  // Date Validators
  // ============================================================
  
  /// Check if date is in the future
  static bool isFutureDate(DateTime? value) =>
      value != null && value.isAfter(DateTime.now());
  
  /// Check if date is in the past
  static bool isPastDate(DateTime? value) =>
      value != null && value.isBefore(DateTime.now());
  
  /// Check if date is today or in the future
  static bool isTodayOrFuture(DateTime? value) {
    if (value == null) return false;
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final valueOnly = DateTime(value.year, value.month, value.day);
    return !valueOnly.isBefore(todayOnly);
  }
  
  /// Check if date is after another date
  static bool isAfterDate(DateTime? value, DateTime other) =>
      value != null && value.isAfter(other);
  
  /// Check if date is before another date
  static bool isBeforeDate(DateTime? value, DateTime other) =>
      value != null && value.isBefore(other);
  
  // ============================================================
  // TextFormField Validators (return String? for error message)
  // ============================================================
  
  /// Create a required field validator for TextFormField
  /// 
  /// Usage:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.required('This field is required'),
  /// )
  /// ```
  static String? Function(String?) required(String message) {
    return (value) => isBlank(value) ? message : null;
  }
  
  /// Create an email validator for TextFormField
  static String? Function(String?) email(String message) {
    return (value) {
      if (isBlank(value)) return null; // Let required handle empty
      return isValidEmail(value) ? null : message;
    };
  }
  
  /// Create a phone validator for TextFormField
  static String? Function(String?) phone(String message) {
    return (value) {
      if (isBlank(value)) return null;
      return isValidPhone(value) ? null : message;
    };
  }
  
  /// Create a min length validator for TextFormField
  static String? Function(String?) minLength(int length, String message) {
    return (value) {
      if (isBlank(value)) return null;
      return hasMinLength(value, length) ? null : message;
    };
  }
  
  /// Create a max length validator for TextFormField
  static String? Function(String?) maxLength(int length, String message) {
    return (value) {
      if (value == null) return null;
      return hasMaxLength(value, length) ? null : message;
    };
  }
  
  /// Create a pattern validator for TextFormField
  static String? Function(String?) pattern(RegExp regex, String message) {
    return (value) {
      if (isBlank(value)) return null;
      return matchesPattern(value, regex) ? null : message;
    };
  }
  
  /// Create a URL validator for TextFormField
  static String? Function(String?) url(String message) {
    return (value) {
      if (isBlank(value)) return null;
      return isValidUrl(value) ? null : message;
    };
  }
  
  /// Combine multiple validators
  /// 
  /// Usage:
  /// ```dart
  /// TextFormField(
  ///   validator: Validators.compose([
  ///     Validators.required('Email is required'),
  ///     Validators.email('Invalid email format'),
  ///   ]),
  /// )
  /// ```
  static String? Function(String?) compose(List<String? Function(String?)> validators) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}
