import 'package:inspector/features/auth/presentation/model/auth_state.dart';

/// Register effects
sealed class RegisterEffect {}

class RegisterNavigateToHome extends RegisterEffect {
  final UserStateModel user;
  RegisterNavigateToHome({required this.user});
}
