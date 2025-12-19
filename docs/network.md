# Network Module

Location: `lib/network/`

**Standalone module** - zero dependencies on core or other modules. Can be extracted as a separate library.

## Structure

```
network/
├── client/
│   ├── client.dart           # barrel
│   └── network_client.dart   # abstract interface
├── error/
│   ├── error.dart            # barrel
│   ├── error_model.dart      # abstract interface
│   └── error_mapper.dart     # abstract + exceptions
└── network_module.dart       # main barrel
```

## NetworkClient

```dart
abstract class NetworkClient {
  Future<T> get<T>(String path, {...});
  Future<T> post<T>(String path, {...});
  Future<T> put<T>(String path, {...});
  Future<T> patch<T>(String path, {...});
  Future<T> delete<T>(String path, {...});
}
```

## ErrorModel

```dart
abstract class ErrorModel {
  String? get message;
  String? get code;
  int? get statusCode;
}
```

## ErrorMapper

```dart
abstract class ErrorMapper<T extends ErrorModel> {
  T parseErrorResponse(dynamic response);
  NetworkException mapToException(T errorModel, {int? statusCode});
}
```

## Exceptions (All in network module)

```
NetworkException
├── ServerException (5xx)
├── UnauthorizedException (401)
├── ForbiddenException (403)
├── NotFoundException (404)
├── BadRequestException (400)
├── TimeoutException
└── NoInternetException
```

## Usage

```dart
import 'package:inspector/network/network_module.dart';

// All interfaces and exceptions available
```

## Concrete Implementations

See `docs/core.md` - implementations are in `lib/core/network/`
