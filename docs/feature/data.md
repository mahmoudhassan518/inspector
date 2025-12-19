# Data Layer

## Response Model

All fields nullable. Implements `fromJson`/`toJson`.

```dart
class UserResponse {
  final String? id;
  
  factory UserResponse.fromJson(Map<String, dynamic> json) => 
    UserResponse(id: json['id']);
  
  Map<String, dynamic> toJson() => {'id': id};
}
```

## Mapper

Extension to convert data ↔ domain:

```dart
extension UserResponseMapper on UserResponse {
  UserEntity toEntity() => UserEntity(id: id);
}
```

## Remote Data Source

Inject `NetworkClient`:

```dart
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final NetworkClient _networkClient;
  
  Future<UserResponse> login(String email, String password) async {
    final response = await _networkClient.post<Map<String, dynamic>>('/auth/login', body: {...});
    return UserResponse.fromJson(response);
  }
}
```

## Repository Impl

Coordinates remote + local sources, uses mapper:

```dart
class AuthRepositoryImpl implements AuthRepository {
  Future<UserEntity> login(...) async {
    final response = await _remoteDataSource.login(...);
    return response.toEntity();
  }
}
```
