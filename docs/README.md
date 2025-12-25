# Architecture Docs

## AI Instructions

| Editing                    | Read First                     |
|----------------------------|--------------------------------|
| `packages/core/`           | `docs/core.md`                 |
| `packages/network/`        | `docs/network.md`              |
| `lib/core/`                | `docs/core.md`                 |
| `lib/core/config/`         | `README_ENVIRONMENTS.md`       |
| `lib/core/utils/`          | This file (Logging section)    |
| `lib/navigation/`          | `docs/navigation.md`           |
| `features/*/navigation/`   | `docs/navigation.md`           |
| `features/*/domain/`       | `docs/feature/domain.md`       |
| `features/*/data/`         | `docs/feature/data.md`         |
| `features/*/presentation/` | `docs/feature/presentation.md` |
| `features/*/di/`           | `docs/feature/di.md`           |

## Project Structure

```
inspector/
├── packages/
│   ├── core/                # Core library (inspector_core)
│   │   └── lib/src/
│   │       ├── bloc/        # BaseBloc, SingleEffect
│   │       ├── common/      # CommonCubit, CommonState
│   │       ├── exceptions/  # AppException hierarchy
│   │       ├── navigation/  # NavigationService
│   │       ├── usecases/    # UseCase base
│   │       └── widgets/     # StateView
│   │
│   └── network/             # Network library (inspector_network)
│       └── lib/src/
│           ├── interfaces/      # NetworkClient, ErrorModel, ErrorMapper, TokenProvider
│           ├── implementations/ # DioNetworkClient, DefaultErrorMapper
│           ├── interceptors/    # LoggingInterceptor, AuthInterceptor, ErrorInterceptor
│           └── exceptions/      # NetworkException, BusinessException
│
├── lib/
│   ├── core/                # App implementations
│   │   ├── config/          # AppConfig, Environment (see README_ENVIRONMENTS.md)
│   │   ├── di/              # core_injection_container.dart
│   │   ├── network/         # TokenProviderImpl, NetworkConfig, AuthHeaderProviderImpl
│   │   ├── utils/           # AppLogger, FieldValidator, Validators
│   │   └── exceptions/      # CommonErrorCodes
│   ├── navigation/          # AppRouter
│   └── features/            # Feature modules
│
└── docs/                    # This documentation
```

## Feature Structure

```
features/{feature}/
├── {feature}_feature.dart   # Barrel export
├── error_codes.dart         # Feature error codes
├── di/                      # Feature DI
├── navigation/              # Feature routes
├── domain/                  # Entities, repositories, use cases
├── data/                    # Data sources, models
└── presentation/            # BLoC, pages, widgets
```

## Docs

- [Environments](../README_ENVIRONMENTS.md) - App configuration & environments
- [Core](./core.md) - Package + app implementations
- [Network](./network.md) - Standalone network package
- [Navigation](./navigation.md) - go_router, per-feature routes
- [Feature](./feature/README.md) - Feature layer guides

## Imports

```dart
import 'package:inspector/core/core.dart';               // App core (includes package)
import 'package:inspector_core/inspector_core.dart';     // Core package only
import 'package:inspector_network/inspector_network.dart'; // Network package
```

## Logging

Use `AppLogger` for all logging. **Do not use `print()` or `debugPrint()` directly.**

```dart
import 'package:inspector/core/core.dart';

// Shorthand methods
AppLogger.d('Debug message');           // Debug level
AppLogger.i('Info message');            // Info level
AppLogger.w('Warning message');         // Warning level
AppLogger.e('Error', error: exception); // Error level with exception

// With custom tag
AppLogger.i('Custom tag', tag: 'MyFeature');

// Network logging (structured)
AppLogger.network('GET', 'https://api.example.com/users');
AppLogger.networkResponse(200, 'https://api.example.com/users', data: responseData);
AppLogger.networkError('GET', 'https://api.example.com/users', message: 'Not found', statusCode: 404);
```

Logging respects `AppConfig.enableLogging`:
- **dev/qa/staging**: Logs appear in console
- **prod**: Logs are suppressed (can be sent to remote service)

## Form Validation

Use `FieldValidator` for state-based validation and `Validators` for common patterns.

### FieldValidator (for BLoC/Cubit states)

```dart
import 'package:inspector/core/core.dart';

// In your state class
class LoginState {
  final String email;
  final bool hasSubmitted;
  
  FieldValidator<String> get emailValidator => FieldValidator(
    value: email,
    rules: [
      ((v) => !hasSubmitted, null), // Skip if not submitted
      ((v) => Validators.isBlank(v), 'Email is required'),
      ((v) => !Validators.isValidEmail(v), 'Invalid email format'),
    ],
  );
  
  bool get isValid => emailValidator.isValid;
}
```

### Validators (for TextFormField)

```dart
import 'package:inspector/core/core.dart';

TextFormField(
  validator: Validators.compose([
    Validators.required('Email is required'),
    Validators.email('Invalid email format'),
  ]),
)

// Or individual validators
TextFormField(validator: Validators.required('Required'))
TextFormField(validator: Validators.minLength(3, 'At least 3 characters'))
TextFormField(validator: Validators.phone('Invalid phone'))
```

### Available Validators

| Method | Description |
|--------|-------------|
| `isEmpty`, `isBlank` | Check null/empty/whitespace |
| `isValidEmail` | Email format |
| `isValidPhone`, `isValidSaudiPhone` | Phone formats |
| `isValidUrl` | URL format |
| `hasMinLength`, `hasMaxLength` | String length |
| `isInRange`, `isPositive` | Number ranges |
| `isFutureDate`, `isPastDate` | Date validation |

## Flow

```
Presentation → Domain → Data → Network
    BLoC    → UseCase → Repo → NetworkClient
```

