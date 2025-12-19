import 'package:get_it/get_it.dart';
import 'package:inspector/core/di/core_injection_container.dart';
import 'package:inspector/features/auth/di/auth_injection_container.dart';

final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> initDependencies() async {
  await initCore();
  
  // Features
  await initAuthFeature();
}
