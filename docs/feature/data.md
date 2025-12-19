# Data Layer

## Response Model

All fields nullable. Implements `fromJson`/`toJson`.

```dart
class UserResponse {
  final String? id;
  final String? name;
  final String? email;
  
  const UserResponse({this.id, this.name, this.email});
  
  factory UserResponse.fromJson(Map<String, dynamic> json) => 
    UserResponse(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
  };
}
```

## Mapper (Extension)

```dart
extension UserResponseMapper on UserResponse {
  UserEntity toEntity() => UserEntity(
    id: id,
    name: name,
    email: email,
  );
}
```

## Remote Data Source

```dart
abstract class AuthRemoteDataSource {
  Future<UserResponse> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final NetworkClient _networkClient;
  
  AuthRemoteDataSourceImpl({required NetworkClient networkClient})
    : _networkClient = networkClient;
  
  @override
  Future<UserResponse> login(String email, String password) async {
    final response = await _networkClient.post<Map<String, dynamic>>(
      '/auth/login',
      body: {'email': email, 'password': password},
    );
    return UserResponse.fromJson(response);
  }
}
```

## Repository Implementation

```dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  
  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;
  
  @override
  Future<UserEntity> login(String email, String password) async {
    final response = await _remoteDataSource.login(email, password);
    return response.toEntity();
  }
}
```
