# Inspector

> 🤖 **AI-Assisted Flutter Project** - Built using agentic AI coding to explore clean architecture patterns.

This project is an experimental Flutter application created to test and demonstrate AI-assisted development workflows. It serves as a reference implementation for Flutter clean architecture with modular design.

## 🎯 Purpose

- **Testing AI agentic coding** - Exploring how AI can assist in building well-structured Flutter applications
- **Clean Architecture reference** - Demonstrating separation of concerns and modular design
- **Reusable patterns** - Creating patterns that can be extracted and reused in other projects

## 📁 Project Structure

```
inspector/
├── packages/                    # Reusable packages
│   └── core/                    # Core library (standalone)
│       ├── pubspec.yaml
│       └── lib/
│           └── src/
│               ├── bloc/        # BaseBloc, SingleEffect
│               ├── common/      # CommonCubit, CommonState
│               ├── exceptions/  # AppException hierarchy
│               ├── network/     # NetworkClient, Interceptors, Exceptions
│               ├── navigation/  # NavigationService
│               ├── usecases/    # UseCase base class
│               └── widgets/     # StateView
│
├── lib/
│   ├── core/                    # App-specific implementations
│   │   ├── di/                  # Dependency Injection
│   │   └── network/             # TokenProvider, Config
│   │
│   ├── navigation/              # App router (go_router)
│   │   └── app_router.dart
│   │
│   └── features/                # Feature modules
│       └── {feature}/
│           ├── domain/          # Entities, Repositories, UseCases
│           ├── data/            # Data sources, Models, Mappers
│           ├── presentation/    # BLoC, Pages, Widgets
│           ├── navigation/      # Feature routes
│           └── di/              # Feature DI
│
├── docs/                        # Architecture documentation
│   ├── README.md                # AI instructions & overview
│   ├── core.md                  # Core package docs
│   ├── navigation.md            # Navigation docs
│   └── feature/                 # Feature layer docs
│
└── pubspec.yaml
```

## 🏗️ Architecture

### Core Package (`packages/core/`)

A **standalone Flutter package** containing reusable utilities:

| Component | Purpose |
|-----------|---------|
| `BaseBloc` | BLoC with error handling & CommonCubit integration |
| `CommonCubit` | Loading states, snackbars, toasts |
| `StateView` | Widget wrapper for loading overlays |
| `NetworkClient` | HTTP client interface + Dio implementation |
| `ErrorInterceptor` | Error mapping to NetworkExceptions |
| `AuthInterceptor` | Token auth + 401 handling |
| `NavigationService` | Programmatic navigation |

### Feature Structure

Each feature follows **Clean Architecture**:

```
Presentation → Domain ← Data
    ↓            ↓        ↓
   BLoC      UseCase    Repository
    ↓            ↓        ↓
  Pages      Entities   DataSources
```

### Dependency Injection

- **GetIt** for service locator
- Modular DI per feature
- Configurable network settings

## 🚀 Getting Started

```bash
# Get dependencies
flutter pub get

# Get package dependencies
cd packages/core && flutter pub get && cd ../..

# Run the app
flutter run
```

## 📚 Documentation

Detailed documentation in `docs/`:

- [`docs/README.md`](docs/README.md) - Overview & AI instructions
- [`docs/core.md`](docs/core.md) - Core package details
- [`docs/navigation.md`](docs/navigation.md) - Navigation setup
- [`docs/feature/`](docs/feature/) - Feature layer guides

## 🛠️ Tech Stack

- **Flutter** - UI framework
- **flutter_bloc** - State management
- **go_router** - Navigation
- **dio** - HTTP client
- **get_it** - Dependency injection
- **equatable** - Value equality

## 📝 Notes

This is an **experimental project** for AI-assisted development. The architecture patterns demonstrated here are designed to be:

- ✅ Modular and testable
- ✅ Scalable for large applications
- ✅ Easy to understand and maintain
- ✅ Reusable across projects

---

*Built with 🤖 AI assistance*
