import 'package:inspector/features/auth/presentation/model/auth_state.dart';

/// Login effects
sealed class LoginEffect {}

class LoginNavigateToHome extends LoginEffect {
  final UserStateModel user;
  LoginNavigateToHome({required this.user});
}
