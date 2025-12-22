# Network Package

Location: `packages/network/`

A **standalone Dart package** for HTTP networking with Dio. No Flutter dependency.

## Install

```yaml
dependencies:
  inspector_network:
    path: packages/network
```

## Exports

```dart
import 'package:inspector_network/inspector_network.dart';
```

## Structure

```
packages/network/lib/src/
├── interfaces/           # Abstract contracts
│   ├── network_client.dart    # NetworkClient (get, post, put, patch, delete)
│   ├── error_model.dart       # ErrorModel (message, code, statusCode)
│   ├── error_mapper.dart      # ErrorMapper<T extends ErrorModel>
│   ├── token_provider.dart    # TokenProvider (getAccessToken, saveTokens, etc.)
│   └── auth_header_provider.dart  # AuthHeaderProvider (buildAuthHeaders)
│
├── implementations/      # Default implementations
│   ├── dio_network_client.dart    # DioNetworkClient
│   ├── default_error_model.dart   # DefaultErrorModel
│   └── default_error_mapper.dart  # DefaultErrorMapper
│
├── interceptors/         # Dio interceptors
│   ├── logging_interceptor.dart   # Request/response logging
│   ├── auth_interceptor.dart      # Token auth + 401 handling
│   └── error_interceptor.dart     # Error mapping to NetworkException
│
└── exceptions/           # Network exceptions
    ├── network_exception.dart     # Base + specific exceptions
    └── business_exception.dart    # API error code exception
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

## Usage

### Basic Setup

```dart
import 'package:dio/dio.dart';
import 'package:inspector_network/inspector_network.dart';

// Create Dio with interceptors
final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));

// Add error interceptor
dio.interceptors.add(
  ErrorInterceptor(errorMapper: DefaultErrorMapper()),
);

// Create client
final networkClient = DioNetworkClient(dio: dio);

// Make requests
final data = await networkClient.get<Map<String, dynamic>>('/users');
```

### With Authentication

```dart
// Implement TokenProvider in your app
class MyTokenProvider implements TokenProvider {
  @override
  Future<String?> getAccessToken() async => prefs.getString('token');
  // ... other methods
}

// Implement AuthHeaderProvider
class MyAuthHeaderProvider implements AuthHeaderProvider {
  @override
  Future<Map<String, String>> buildAuthHeaders(String accessToken) async {
    return {'Authorization': 'Bearer $accessToken'};
  }
}

// Add auth interceptor
dio.interceptors.add(
  AuthInterceptor(
    tokenProvider: myTokenProvider,
    headerProvider: myAuthHeaderProvider,
    onUnauthorized: () => navigateToLogin(),
  ),
);
```

### Error Handling

```dart
try {
  await networkClient.get('/protected-resource');
} on BusinessException catch (e) {
  // Handle API error codes
  switch (e.errorCode) {
    case 'USER_NOT_VERIFIED':
      showVerificationScreen();
    default:
      showError(e.message);
  }
} on UnauthorizedException {
  // 401 - redirect to login
} on NoInternetException {
  showOfflineMessage();
} on NetworkException catch (e) {
  showError(e.message);
}
```

## Custom Error Mapping

Create custom ErrorModel and ErrorMapper for your API:

```dart
class MyErrorModel implements ErrorModel {
  @override
  final String? message;
  @override
  final String? code;
  @override
  final int? statusCode;
  final List<String>? validationErrors;

  MyErrorModel({this.message, this.code, this.statusCode, this.validationErrors});

  factory MyErrorModel.fromJson(Map<String, dynamic> json) {
    return MyErrorModel(
      message: json['error_message'],
      code: json['error_code'],
      statusCode: json['status'],
      validationErrors: (json['errors'] as List?)?.cast<String>(),
    );
  }
}

class MyErrorMapper extends ErrorMapper<MyErrorModel> {
  @override
  MyErrorModel parseErrorResponse(dynamic response) {
    if (response is Map<String, dynamic>) {
      return MyErrorModel.fromJson(response);
    }
    return MyErrorModel(message: 'Unknown error');
  }

  @override
  NetworkException mapToException(MyErrorModel errorModel, {int? statusCode}) {
    // Custom mapping logic
    if (errorModel.code != null) {
      return BusinessException(
        errorCode: errorModel.code!,
        message: errorModel.message,
        data: errorModel.validationErrors,
      );
    }
    return DefaultErrorMapper().mapToException(
      DefaultErrorModel(
        message: errorModel.message,
        code: errorModel.code,
        statusCode: statusCode,
      ),
      statusCode: statusCode,
    );
  }
}
```

## Interceptor Order

Add interceptors in this order:

1. `LoggingInterceptor` - logs all requests (optional)
2. `ErrorInterceptor` - maps errors (skips 401)
3. `AuthInterceptor` - handles auth headers and 401

```dart
dio.interceptors.addAll([
  LoggingInterceptor(),          // 1. Log everything
  ErrorInterceptor(errorMapper: sl()), // 2. Map errors
  AuthInterceptor(               // 3. Auth + 401
    tokenProvider: sl(),
    headerProvider: sl(),
  ),
]);
```
