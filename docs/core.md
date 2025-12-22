# Core Package

Location: `packages/core/`

A **Flutter package** containing reusable utilities for Flutter apps.

> **Note:** Network functionality has been moved to the separate `inspector_network` package. See [network.md](./network.md).

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
├── usecases/             # UseCase<T, Params>
└── widgets/              # StateView
```

## Components

| Component | Purpose |
|-----------|---------|
| `BaseBloc` | BLoC with error handling & CommonCubit integration |
| `CommonCubit` | Loading states, snackbars, toasts |
| `StateView` | Widget wrapper for loading overlays |
| `NavigationService` | Programmatic navigation |
| `UseCase<T, Params>` | Use case pattern base class |

---

# App Core

Location: `lib/core/`

App-specific implementations that extend the core and network packages.

```
lib/core/
├── core.dart                 # Re-exports package
├── di/
│   └── core_injection_container.dart
├── network/
│   ├── token_provider_impl.dart     # TokenProvider implementation
│   ├── auth_header_providers_impl.dart  # AuthHeaderProvider implementation
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
import 'package:inspector_network/inspector_network.dart';

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
- TokenProvider, ErrorMapper (from `inspector_network`)
- Dio (with interceptors)
- NetworkClient
