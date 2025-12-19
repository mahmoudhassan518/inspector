/// Auth effects - single-use navigation/UI effects
sealed class AuthEffect {
  const AuthEffect();
}

/// Navigate to home after successful login
class NavigateToHome extends AuthEffect {
  const NavigateToHome();
}

/// Navigate to login page
class NavigateToLogin extends AuthEffect {
  const NavigateToLogin();
}

/// Show error message
class ShowError extends AuthEffect {
  final String message;

  const ShowError(this.message);
}

/// Show success message
class ShowSuccess extends AuthEffect {
  final String message;

  const ShowSuccess(this.message);
}
