import 'package:equatable/equatable.dart';

import 'package:inspector/core/core.dart';
import 'package:inspector/features/auth/domain/model/user_entity.dart';
import 'package:inspector/features/auth/domain/repository/auth_repository.dart';

/// Login use case
class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<UserEntity> call(LoginParams params) {
    return repository.login(params.email, params.password);
  }
}

/// Login parameters
class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
