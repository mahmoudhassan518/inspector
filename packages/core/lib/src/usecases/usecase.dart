import 'package:equatable/equatable.dart';

/// Base use case - throws AppException on failure
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// Use for use cases that don't require parameters
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
