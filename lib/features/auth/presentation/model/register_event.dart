/// Register events
sealed class RegisterEvent {}

class RegisterNameChanged extends RegisterEvent {
  final String name;
  RegisterNameChanged(this.name);
}

class RegisterEmailChanged extends RegisterEvent {
  final String email;
  RegisterEmailChanged(this.email);
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;
  RegisterPasswordChanged(this.password);
}

class RegisterConfirmPasswordChanged extends RegisterEvent {
  final String confirmPassword;
  RegisterConfirmPasswordChanged(this.confirmPassword);
}

class RegisterBirthDateChanged extends RegisterEvent {
  final DateTime birthDate;
  RegisterBirthDateChanged(this.birthDate);
}

class RegisterSubmitted extends RegisterEvent {}

class RegisterReset extends RegisterEvent {}
