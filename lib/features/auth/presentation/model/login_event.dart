/// Login events
sealed class LoginEvent {}

class LoginEmailChanged extends LoginEvent {
  final String email;
  LoginEmailChanged(this.email);
}

class LoginPasswordChanged extends LoginEvent {
  final String password;
  LoginPasswordChanged(this.password);
}

class LoginRememberMeToggled extends LoginEvent {}

class LoginSubmitted extends LoginEvent {}

class LoginReset extends LoginEvent {}
