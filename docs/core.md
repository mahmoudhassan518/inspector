# Core Package

Location: `packages/core/`

## Exports

```dart
import 'package:inspector_core/inspector_core.dart';
```

## Structure

```
packages/core/lib/src/
├── bloc/                 # BaseBloc, SingleEffect
├── common/               # CommonCubit, CommonState, AlertType
├── exceptions/           # AppException, CacheException, ValidationException
├── navigation/           # NavigationService, withRebuildKey
├── network/
│   ├── interfaces/       # NetworkClient, ErrorModel, ErrorMapper, TokenProvider
│   ├── implementations/  # DioNetworkClient, DefaultErrorMapper
│   ├── interceptors/     # LoggingInterceptor, AuthInterceptor, ErrorInterceptor
│   └── exceptions/       # NetworkException, BusinessException
├── usecases/             # UseCase<T, Params>
└── widgets/              # StateView
```

## Network Exceptions

| Exception | Trigger |
|-----------|---------|
| `NetworkException` | Base |
| `BusinessException` | API error code (has `errorCode`) |
| `ServerException` | 5xx |
| `UnauthorizedException` | 401 |
| `BadRequestException` | 400 |
| `ForbiddenException` | 403 |
| `NotFoundException` | 404 |
| `NoInternetException` | No connection |
| `TimeoutException` | Timeout |

---

# App Core

Location: `lib/core/`

```
lib/core/
├── core.dart                 # Re-exports package
├── di/
│   └── core_injection_container.dart
├── network/
│   ├── token_provider_impl.dart
│   ├── auth_header_providers.dart
│   └── network_config.dart
└── exceptions/
    └── error_codes.dart      # CommonErrorCodes
```

## Error Codes

**Common (shared):** `lib/core/exceptions/error_codes.dart`
```dart
abstract class CommonErrorCodes {
  static const invalidInput = 'INVALID_INPUT';
  static const resourceNotFound = 'RESOURCE_NOT_FOUND';
}
```

**Per-feature:** `lib/features/{feature}/error_codes.dart`
```dart
abstract class AuthErrorCodes {
  static const userNotVerified = 'USER_NOT_VERIFIED';
  static const invalidCredentials = 'INVALID_CREDENTIALS';
}
```

## Handling in BLoC

```dart
import 'package:inspector/features/auth/error_codes.dart';

launchBlock(
  onError: (error, message) {
    if (error is BusinessException) {
      switch (error.errorCode) {
        case AuthErrorCodes.userNotVerified:
          emit(state.copyWith(needsVerification: true));
        default:
          showError(error.message ?? 'Error');
      }
    }
  },
  block: () async { ... },
);
```

## DI Setup

`lib/core/di/core_injection_container.dart`:
- SharedPreferences
- CommonCubit (global)
- TokenProvider, ErrorMapper
- Dio (with interceptors)
- NetworkClient
