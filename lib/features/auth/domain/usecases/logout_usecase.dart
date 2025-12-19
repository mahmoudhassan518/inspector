import 'package:inspector/core/core.dart';
import 'package:inspector/features/auth/domain/repository/auth_repository.dart';

/// Logout use case
class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<void> call(NoParams params) {
    return repository.logout();
  }
}
