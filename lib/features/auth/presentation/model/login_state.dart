import 'package:equatable/equatable.dart';
import 'package:inspector/core/core.dart';
import 'package:inspector/features/auth/presentation/model/login_effect.dart';
import 'package:inspector/features/localization/localization_feature.dart';

/// Login state with form data and validation
/// 
/// Uses FieldValidator pattern for language-aware validation.
/// Errors are recalculated when widget rebuilds (e.g., on language change).
class LoginState extends Equatable {
  final String email;
  final String password;
  final bool rememberMe;
  final bool hasSubmitted;
  final SingleEffect<LoginEffect>? effect;

  const LoginState({
    this.email = '',
    this.password = '',
    this.rememberMe = false,
    this.hasSubmitted = false,
    this.effect,
  });

  factory LoginState.initial() => const LoginState();

  LoginState copyWith({
    String? email,
    String? password,
    bool? rememberMe,
    bool? hasSubmitted,
    SingleEffect<LoginEffect>? effect,
    bool clearEffect = false,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      effect: clearEffect ? null : (effect ?? this.effect),
    );
  }

  // ============================================================
  // Validators - recalculated on each access (language-aware)
  // ============================================================

  /// Email validation
  /// - Required
  /// - Must be valid email format
  FieldValidator<String> get emailValidator => FieldValidator(
    value: email,
    rules: [
      // Skip validation if form hasn't been submitted yet
      ((v) => !hasSubmitted, null),
      // Required check
      ((v) => Validators.isBlank(v), AppStrings.current.pleaseEnterEmail),
      // Format check
      ((v) => !Validators.isValidEmail(v), AppStrings.current.pleaseEnterValidEmail),
    ],
  );

  /// Password validation
  /// - Required
  /// - Minimum 6 characters
  FieldValidator<String> get passwordValidator => FieldValidator(
    value: password,
    rules: [
      ((v) => !hasSubmitted, null),
      ((v) => Validators.isBlank(v), AppStrings.current.pleaseEnterPassword),
      ((v) => !Validators.hasMinLength(v, 6), AppStrings.current.passwordMinLength),
    ],
  );

  /// Check if form is valid (all validators pass)
  bool get isValid => emailValidator.isValid && passwordValidator.isValid;

  @override
  List<Object?> get props => [email, password, rememberMe, hasSubmitted, effect];
}
