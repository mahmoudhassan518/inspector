import 'package:equatable/equatable.dart';
import 'package:inspector/core/core.dart';
import 'package:inspector/features/auth/presentation/model/register_effect.dart';
import 'package:inspector/features/localization/localization_feature.dart';

/// Register state with form data and validation
/// 
/// Uses FieldValidator pattern for language-aware validation.
/// Includes example of date field validation.
class RegisterState extends Equatable {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final DateTime? birthDate;
  final bool hasSubmitted;
  final SingleEffect<RegisterEffect>? effect;

  const RegisterState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.birthDate,
    this.hasSubmitted = false,
    this.effect,
  });

  factory RegisterState.initial() => const RegisterState();

  RegisterState copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    DateTime? birthDate,
    bool? hasSubmitted,
    SingleEffect<RegisterEffect>? effect,
    bool clearEffect = false,
    bool clearBirthDate = false,
  }) {
    return RegisterState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      birthDate: clearBirthDate ? null : (birthDate ?? this.birthDate),
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      effect: clearEffect ? null : (effect ?? this.effect),
    );
  }

  // ============================================================
  // Validators - recalculated on each access (language-aware)
  // ============================================================

  /// Name validation
  FieldValidator<String> get nameValidator => FieldValidator(
    value: name,
    rules: [
      ((v) => !hasSubmitted, null),
      ((v) => Validators.isBlank(v), AppStrings.current.pleaseEnterName),
      ((v) => !Validators.hasMinLength(v, 2), AppStrings.current.pleaseEnterName),
    ],
  );

  /// Email validation
  FieldValidator<String> get emailValidator => FieldValidator(
    value: email,
    rules: [
      ((v) => !hasSubmitted, null),
      ((v) => Validators.isBlank(v), AppStrings.current.pleaseEnterEmail),
      ((v) => !Validators.isValidEmail(v), AppStrings.current.pleaseEnterValidEmail),
    ],
  );

  /// Password validation
  FieldValidator<String> get passwordValidator => FieldValidator(
    value: password,
    rules: [
      ((v) => !hasSubmitted, null),
      ((v) => Validators.isBlank(v), AppStrings.current.pleaseEnterPassword),
      ((v) => !Validators.hasMinLength(v, 6), AppStrings.current.passwordMinLength),
    ],
  );

  /// Confirm password validation
  FieldValidator<String> get confirmPasswordValidator => FieldValidator(
    value: confirmPassword,
    rules: [
      ((v) => !hasSubmitted, null),
      ((v) => Validators.isBlank(v), AppStrings.current.pleaseEnterPassword),
      ((v) => v != password, AppStrings.current.passwordsDoNotMatch),
    ],
  );

  /// Birth date validation (example of non-string field)
  /// - Required
  /// - Must be in the past
  /// - User must be at least 18 years old
  FieldValidator<DateTime?> get birthDateValidator => FieldValidator(
    value: birthDate,
    rules: [
      ((v) => !hasSubmitted, null),
      ((v) => v == null, AppStrings.current.pleaseSelectBirthDate),
      ((v) => v != null && !_isAtLeast18(v), AppStrings.current.mustBeAtLeast18),
    ],
  );

  bool _isAtLeast18(DateTime date) {
    final today = DateTime.now();
    final age = today.year - date.year;
    if (today.month < date.month || 
        (today.month == date.month && today.day < date.day)) {
      return age - 1 >= 18;
    }
    return age >= 18;
  }

  /// Check if form is valid
  bool get isValid => 
    nameValidator.isValid && 
    emailValidator.isValid && 
    passwordValidator.isValid && 
    confirmPasswordValidator.isValid &&
    birthDateValidator.isValid;

  @override
  List<Object?> get props => [
    name, 
    email, 
    password, 
    confirmPassword, 
    birthDate, 
    hasSubmitted, 
    effect,
  ];
}
