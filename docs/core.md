# Core Package

Location: `packages/core/`

**Complete reusable Flutter package** with everything included.

## Installation

```yaml
dependencies:
  inspector_core:
    path: packages/core
```

## Package Contents

### Bloc
- `BaseBloc` - Error handling, CommonCubit integration
- `SingleEffect` - One-time effect wrapper

### Common
- `CommonCubit` - Loading/snackbar state management
- `StateView` - Wrapper widget for loading overlay

### Exceptions
- `AppException`, `CacheException`, `ValidationException`

### Network (Complete)

**Interfaces:**
- `NetworkClient` - HTTP operations
- `ErrorModel` - Error response structure
- `ErrorMapper<T>` - Error mapping
- `TokenProvider` - Token management (app implements)

**Implementations:**
- `DioNetworkClient` - Dio HTTP client
- `DefaultErrorModel` - Default error model
- `DefaultErrorMapper` - Default error mapper
- `LoggingInterceptor` - Request/response logging
- `AuthInterceptor` - Token auth + 401 handling

**Exceptions:**
- `NetworkException`, `ServerException`, `UnauthorizedException`, etc.

---

# App Core

Location: `lib/core/`

## Structure

```
lib/core/
├── core.dart                           # Barrel (package + app implementations)
├── di/
│   └── core_injection_container.dart   # DI with NetworkConfig
└── network/
    ├── token_provider_impl.dart        # SharedPrefs TokenProvider
    └── network_config.dart             # Configuration class
```

## NetworkConfig

Configure interceptors via `networkConfig` before calling `initCore()`:

```dart
// In main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure before DI
  networkConfig = NetworkConfig(
    baseUrl: 'https://api.yourapp.com',
    enableLogging: kDebugMode,  // Only in debug
    enableAuth: true,
  );

  await initDependencies();
  runApp(const App());
}
```

## NetworkConfig Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `baseUrl` | `String` | required | API base URL |
| `enableLogging` | `bool` | `true` | Enable LoggingInterceptor |
| `enableAuth` | `bool` | `true` | Enable AuthInterceptor |
| `connectTimeoutSeconds` | `int` | `30` | Connection timeout |
| `receiveTimeoutSeconds` | `int` | `30` | Receive timeout |
| `sendTimeoutSeconds` | `int` | `30` | Send timeout |

## TokenProviderImpl

App provides SharedPreferences-based TokenProvider:

```dart
// Registered automatically in initCore()
sl.registerLazySingleton<TokenProvider>(
  () => TokenProviderImpl(prefs: sl<SharedPreferences>()),
);
```

## Usage

```dart
// Import everything (package + app implementations)
import 'package:inspector/core/core.dart';
```
