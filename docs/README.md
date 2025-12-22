# Architecture Docs

## AI Instructions

| Editing | Read First |
|---------|------------|
| `packages/core/` | `docs/core.md` |
| `packages/network/` | `docs/network.md` |
| `lib/core/` | `docs/core.md` |
| `lib/navigation/` | `docs/navigation.md` |
| `features/*/navigation/` | `docs/navigation.md` |
| `features/*/domain/` | `docs/feature/domain.md` |
| `features/*/data/` | `docs/feature/data.md` |
| `features/*/presentation/` | `docs/feature/presentation.md` |
| `features/*/di/` | `docs/feature/di.md` |

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
│   │   ├── di/              # core_injection_container.dart
│   │   ├── network/         # TokenProviderImpl, NetworkConfig, AuthHeaderProviderImpl
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

## Flow

```
Presentation → Domain → Data → Network
    BLoC    → UseCase → Repo → NetworkClient
```
