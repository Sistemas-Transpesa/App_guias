import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';
import 'core/di/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables (.env)
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // If .env file fails to load, defaults in ApiEndpoints are used
  }

  // Initialize Clean Architecture Service Locator (GetIt)
  await initServiceLocator();

  // Launch Flutter App
  runApp(const GuiasApp());
}
