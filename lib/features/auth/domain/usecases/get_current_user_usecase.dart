import 'package:inspector/core/core.dart';
import 'package:inspector/features/auth/domain/model/user_entity.dart';
import 'package:inspector/features/auth/domain/repository/auth_repository.dart';

/// Get current user use case
class GetCurrentUserUseCase implements UseCase<UserEntity?, NoParams> {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<UserEntity?> call(NoParams params) {
    return repository.getCurrentUser();
  }
}
