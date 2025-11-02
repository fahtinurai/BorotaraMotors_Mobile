// lib/main.dart
import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'services/local_storage_service.dart';
import 'ui/auth/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init storage + seed user default (admin, driver1, teknisi1)
  final storage = LocalStorageService();
  await storage.init();
  await storage.ensureSeedUsers();

  runApp(const BorotaraApp());
}

class BorotaraApp extends StatelessWidget {
  const BorotaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Borotara',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light, // pastikan app_theme.dart ada ini
      home: const HomePage(),
    );
  }
}
