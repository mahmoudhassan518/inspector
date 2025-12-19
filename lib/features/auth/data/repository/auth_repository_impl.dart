import 'package:inspector/features/auth/domain/model/user_entity.dart';
import 'package:inspector/features/auth/domain/repository/auth_repository.dart';
import 'package:inspector/features/auth/data/model/mapper/user_mapper.dart';
import 'package:inspector/features/auth/data/source/auth_local_data_source.dart';
import 'package:inspector/features/auth/data/source/auth_remote_data_source.dart';

/// Implementation of [AuthRepository]
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<UserEntity> login(String email, String password) async {
    final response = await _remoteDataSource.login(email, password);

    // Cache user and tokens
    await _localDataSource.cacheUser(response);
    if (response.accessToken != null) {
      await _localDataSource.saveAccessToken(response.accessToken!);
    }
    if (response.refreshToken != null) {
      await _localDataSource.saveRefreshToken(response.refreshToken!);
    }

    return response.toEntity();
  }

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await _remoteDataSource.register(
      email: email,
      password: password,
      name: name,
    );

    // Cache user and tokens
    await _localDataSource.cacheUser(response);
    if (response.accessToken != null) {
      await _localDataSource.saveAccessToken(response.accessToken!);
    }
    if (response.refreshToken != null) {
      await _localDataSource.saveRefreshToken(response.refreshToken!);
    }

    return response.toEntity();
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
    await _localDataSource.clearCache();
    await _localDataSource.clearTokens();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    // Try to get from cache first
    final cached = await _localDataSource.getCachedUser();
    if (cached != null) {
      return cached.toEntity();
    }

    // If not cached, fetch from remote
    final isLoggedIn = await _localDataSource.isLoggedIn();
    if (!isLoggedIn) return null;

    final response = await _remoteDataSource.getCurrentUser();
    await _localDataSource.cacheUser(response);
    return response.toEntity();
  }

  @override
  Future<bool> isLoggedIn() {
    return _localDataSource.isLoggedIn();
  }
}
