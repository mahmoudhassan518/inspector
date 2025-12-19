# Domain Layer

Pure Dart + Equatable only. No external dependencies.

## Entity

```dart
class UserEntity extends Equatable {
  final String? id;
  final String? name;
  final String? email;
  
  const UserEntity({this.id, this.name, this.email});
  
  @override
  List<Object?> get props => [id, name, email];
}
```

## Repository (Abstract)

```dart
abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<void> logout();
}
```

## UseCase

```dart
class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;
  
  LoginUseCase(this.repository);
  
  @override
  Future<UserEntity> call(LoginParams params) => 
    repository.login(params.email, params.password);
}

class LoginParams {
  final String email;
  final String password;
  
  LoginParams({required this.email, required this.password});
}
```
