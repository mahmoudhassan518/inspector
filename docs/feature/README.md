# Feature Structure

```
features/{feature}/
├── {feature}_feature.dart      # Barrel export
├── error_codes.dart            # Feature error codes
├── di/
│   └── {feature}_injection_container.dart
├── navigation/
│   └── {feature}_routes.dart
├── data/
│   ├── model/
│   │   ├── {name}_response.dart
│   │   └── mapper/{name}_mapper.dart
│   ├── repository/
│   └── source/
├── domain/
│   ├── model/{name}_entity.dart
│   ├── repository/
│   └── usecases/
└── presentation/
    ├── model/
    │   ├── {feature}_events.dart
    │   ├── {feature}_effects.dart
    │   └── {feature}_state.dart
    ├── bloc/
    ├── view/
    └── widget/
```

## Feature Barrel

`{feature}_feature.dart`:
```dart
export 'di/{feature}_injection_container.dart';
export 'presentation/view/login_page.dart';
export 'presentation/view/register_page.dart';
```

## Error Codes

Each feature has `error_codes.dart`:

```dart
abstract class AuthErrorCodes {
  static const userNotVerified = 'USER_NOT_VERIFIED';
  static const invalidCredentials = 'INVALID_CREDENTIALS';
}
```

Use in BLoC:
```dart
if (error is BusinessException) {
  switch (error.errorCode) {
    case AuthErrorCodes.userNotVerified:
      // handle
  }
}
```

## Layer Docs

- [Domain](./domain.md)
- [Data](./data.md)
- [Presentation](./presentation.md)
- [DI](./di.md)
