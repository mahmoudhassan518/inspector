# Domain Layer

No external dependencies. Pure Dart + Equatable only.

## Entity

```dart
class UserEntity extends Equatable {
  final String? id;
  final String? name;
  
  @override
  List<Object?> get props => [id, name];
}
```

## Repository (Abstract)

```dart
abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
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
```
