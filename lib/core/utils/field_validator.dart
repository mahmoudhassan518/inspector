/// Validation rule that returns true if the value fails validation
/// 
/// The tuple contains:
/// - A test function that returns `true` when validation FAILS
/// - An error message to display when validation fails (null to skip)
typedef ValidationRule<T> = (bool Function(T value) test, String? message);

/// Generic field validator for form validation
/// 
/// Usage:
/// ```dart
/// final emailValidator = FieldValidator<String>(
///   value: email,
///   rules: [
///     ((v) => v.isEmpty, 'Email is required'),
///     ((v) => !v.contains('@'), 'Invalid email format'),
///   ],
/// );
/// 
/// if (emailValidator.isValid) {
///   // proceed
/// } else {
///   showError(emailValidator.errorMessage);
/// }
/// ```
/// 
/// With hasSubmitted pattern (skip validation until form is submitted):
/// ```dart
/// FieldValidator<String>(
///   value: email,
///   rules: [
///     ((v) => !hasSubmitted, null), // Skip if not submitted yet
///     ((v) => v.isEmpty, 'Email is required'),
///   ],
/// );
/// ```
class FieldValidator<T> {
  /// The value to validate
  final T value;
  
  /// List of validation rules
  /// Each rule is a tuple of (test, message)
  /// Test returns true when validation FAILS
  final List<ValidationRule<T>> rules;

  FieldValidator({
    required this.value, 
    required this.rules,
  });

  /// Get the first error message, or null if valid
  String? get errorMessage {
    for (final rule in rules) {
      if (rule.$1(value)) return rule.$2;
    }
    return null;
  }

  /// Check if the value passes all validation rules
  bool get isValid => errorMessage == null;
  
  /// Check if the value fails any validation rule
  bool get hasError => !isValid;
}

/// Extension to easily create validators for nullable values
extension NullableFieldValidator<T> on FieldValidator<T?> {
  /// Check if value is null
  bool get isNull => value == null;
  
  /// Check if value is not null
  bool get isNotNull => value != null;
}

/// Extension for String validators
extension StringFieldValidator on FieldValidator<String> {
  /// Check if string is empty or whitespace only
  bool get isBlank => value.trim().isEmpty;
  
  /// Check if string has content
  bool get isNotBlank => !isBlank;
}
