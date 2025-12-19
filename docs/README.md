# Architecture Docs

## ⚠️ AI Instructions

1. **READ docs before editing code** - see table below
2. **DO NOT edit any docs/** files unless user explicitly asks

| Editing | Read First |
|---------|------------|
| `packages/core/` | `docs/core.md` |
| `lib/core/` | `docs/core.md` |
| `lib/navigation/` | `docs/navigation.md` |
| `features/*/navigation/` | `docs/navigation.md` |
| `features/*/domain/` | `docs/feature/domain.md` |
| `features/*/data/` | `docs/feature/data.md` |
| `features/*/presentation/` | `docs/feature/presentation.md` |
| `features/*/di/` | `docs/feature/di.md` |
| `injection_container.dart` | `docs/core.md` |

## Structure

| Location | Purpose |
|----------|---------|
| `packages/core/` | Interfaces & base classes (reusable library) |
| `lib/core/` | App implementations (TokenProvider, config) |
| `lib/navigation/` | App router configuration |
| `lib/features/` | App features |

## Feature Structure

```
features/{feature}/
├── domain/          # Entities, repositories, use cases
├── data/            # Data sources, models, mappers
├── presentation/    # BLoC, pages, widgets
├── navigation/      # Feature routes
└── di/              # Feature DI
```

## Navigation

- [Navigation](./navigation.md) - go_router setup, per-feature routes
- [Core](./core.md) - Package interfaces + App implementations  
- [Feature Structure](./feature/README.md) - How to structure features

## Imports

```dart
// App core (includes package + implementations)
import 'package:inspector/core/core.dart';

// Navigation
import 'package:inspector/navigation/navigation.dart';

// Feature navigation
import 'package:inspector/features/auth/navigation/auth_routes.dart';
```

## Layer Flow

```
Presentation → Domain → Data → Network
    BLoC    → UseCase → Repo → NetworkClient

Navigation (go_router)
    AppRouter → FeatureRoutes → Pages
```
