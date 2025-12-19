import 'package:equatable/equatable.dart';

import 'package:inspector/core/core.dart';
import 'package:inspector/features/auth/domain/model/user_entity.dart';
import 'package:inspector/features/auth/domain/repository/auth_repository.dart';

/// Register use case
class RegisterUseCase implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<UserEntity> call(RegisterParams params) {
    return repository.register(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
}

/// Register parameters
class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String name;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}
