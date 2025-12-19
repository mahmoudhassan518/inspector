import 'package:equatable/equatable.dart';

/// Auth BLoC events
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Login requested event
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Register requested event
class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const RegisterRequested({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

/// Logout requested event
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

/// Check auth status event
class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}
