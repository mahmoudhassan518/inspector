# Flutter Environment Configuration

This project uses a **refactored configuration system** that automatically reads settings from build-time constants and environment variables.

## Available Environments

| Environment | Description       | App Name          | Bundle ID Suffix | Logging | Analytics |
|-------------|-------------------|-------------------|------------------|---------|-----------|
| `dev`       | Development       | Inspector Dev     | `.dev`           | ✅       | ❌         |
| `qa`        | Quality Assurance | Inspector QA      | `.qa`            | ✅       | ❌         |
| `staging`   | Staging           | Inspector Staging | `.staging`       | ✅       | ✅         |
| `prod`      | Production        | Inspector         | (none)           | ❌       | ✅         |

## Quick Start

### Using Flutter Commands

#### Debug Builds
```bash
# Development with full logging
flutter run --dart-define=FLAVOR=dev

# QA with logging but no analytics
flutter run --dart-define=FLAVOR=qa

# Staging with logging and analytics
flutter run --dart-define=FLAVOR=staging

# Production - minimal logging, full analytics
flutter run --dart-define=FLAVOR=prod
```

#### Release Builds
```bash
# Android APK for QA
flutter build apk --dart-define=FLAVOR=qa --release

# Android App Bundle (for Play Store)
flutter build appbundle --dart-define=FLAVOR=prod --release

# iOS (for App Store)
flutter build ios --dart-define=FLAVOR=prod --release
```

## Configuration System

### AppConfig Class
The `AppConfig` class in `lib/core/config/app_config.dart` handles all configuration logic:

```dart
import 'package:inspector/core/core.dart';

// Initialize at app start (in main.dart)
AppConfig.initialize();

// Access current configuration
AppConfig.instance.baseUrl        // API base URL
AppConfig.instance.portalUrl      // Web portal URL
AppConfig.instance.appName        // App display name
AppConfig.instance.enableLogging  // Logging enabled/disabled
AppConfig.instance.isProduction   // Is production environment

// Environment detection
AppConfig.instance.environment    // Current environment enum
AppConfig.instance.isDevelopment  // Quick boolean checks
AppConfig.instance.isQA
AppConfig.instance.isStaging
```

### Automatic Detection
Configuration is automatically detected from:
1. **Dart Define Constants**: `--dart-define=FLAVOR=dev`
2. **Build Mode**: Debug → dev, Profile → staging, Release → prod

### Environment-Specific URLs

| Environment | Base URL                                    | Portal URL                           |
|-------------|---------------------------------------------|--------------------------------------|
| **dev**     | `https://dev-api.inspector.example.com/api` | `https://dev.inspector.example.com`  |
| **qa**      | `https://qa-api.inspector.example.com/api`  | `https://qa.inspector.example.com`   |
| **staging** | `https://staging-api.inspector.example.com/api` | `https://staging.inspector.example.com` |
| **prod**    | `https://api.inspector.example.com/api`     | `https://inspector.example.com`      |

> **Note:** These are dummy URLs. Replace with actual values in `lib/core/config/app_config.dart`.

## VS Code Integration

Create `.vscode/launch.json` for easy environment switching:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Inspector Dev",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define=FLAVOR=dev"]
    },
    {
      "name": "Inspector QA",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define=FLAVOR=qa"]
    },
    {
      "name": "Inspector Staging",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define=FLAVOR=staging"]
    },
    {
      "name": "Inspector Prod",
      "request": "launch",
      "type": "dart",
      "args": ["--dart-define=FLAVOR=prod"]
    }
  ]
}
```

## Advanced Configuration

### Custom Environment Variables
You can override default values using dart-define:

```bash
flutter run \
  --dart-define=FLAVOR=dev \
  --dart-define=BASE_URL=https://custom-api.example.com \
  --dart-define=PORTAL_URL=https://custom.example.com \
  --dart-define=ENABLE_LOGGING=true \
  --dart-define=API_KEY=custom-key-123 \
  --dart-define=GOOGLE_MAPS_KEY=your-maps-key
```

### CI/CD Integration
For CI/CD pipelines, set environment variables:

```yaml
# GitHub Actions example
- name: Build App
  run: |
    flutter build appbundle \
      --dart-define=FLAVOR=prod \
      --dart-define=API_KEY=${{ secrets.PROD_API_KEY }} \
      --dart-define=BASE_URL=${{ vars.PROD_BASE_URL }}
```

## Debug Information

In development builds, configuration is automatically logged to console:

```
╔══════════════════════════════════════════╗
║         APP CONFIGURATION                ║
╠══════════════════════════════════════════╣
║ environment: dev
║ appName: Inspector Dev
║ baseUrl: https://dev-api.inspector.example.com/api
║ portalUrl: https://dev.inspector.example.com
║ enableLogging: true
║ enableAnalytics: false
║ isDebugMode: true
║ platform: android
╚══════════════════════════════════════════╝
```

## Usage in Code

### In main.dart
```dart
import 'package:inspector/core/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize configuration first
  AppConfig.initialize();
  AppConfig.instance.logConfiguration(); // Optional: log config

  // Then initialize DI
  await initCore();

  runApp(const MyApp());
}
```

### In Feature Code
```dart
import 'package:inspector/core/core.dart';

class MyService {
  void doSomething() {
    final config = AppConfig.instance;
    
    if (config.isDevelopment) {
      // Dev-only behavior
    }
    
    final apiUrl = config.baseUrl;
    final portalUrl = config.portalUrl;
  }
}
```

### Via Dependency Injection
```dart
// AppConfig is registered in DI during initCore()
final config = sl<AppConfig>();
print(config.environment);
```

## Troubleshooting

### Configuration Not Loading
1. Check that `--dart-define=FLAVOR=xxx` is set correctly
2. Verify VS Code launch configuration includes dart-define
3. Ensure `AppConfig.initialize()` is called before `initCore()`

### Wrong Environment Detected
1. Check console output for detected environment
2. Verify dart-define parameters are correct
3. Clear Flutter cache: `flutter clean && flutter pub get`

### Different URLs in Dev/Prod
Configuration automatically switches based on environment. Check the environment detection logic in `AppConfig._detectEnvironment()`.
