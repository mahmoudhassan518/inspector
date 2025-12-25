import 'package:flutter/material.dart';

import 'package:inspector/app.dart';
import 'package:inspector/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await initDependencies();

  runApp(const InspectorApp());
}
