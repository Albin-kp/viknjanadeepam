import 'package:flutter/material.dart';

import 'screens/admin/admin_screen.dart';
import 'screens/library_screen.dart';
import 'services/catalog_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CatalogService.initialize();
  runApp(const VijnanaDeepamApp());
}

class VijnanaDeepamApp extends StatelessWidget {
  const VijnanaDeepamApp({super.key});

  static const forest = Color(0xFF173F35);
  static const saffron = Color(0xFFD88A2D);
  static const paper = Color(0xFFF7F3E9);
  static const ink = Color(0xFF24251F);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vijnana Deepam',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: paper,
        colorScheme: ColorScheme.fromSeed(
          seedColor: forest,
          primary: forest,
          secondary: saffron,
          surface: paper,
        ),
        textTheme: const TextTheme(
          displaySmall: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 38,
            height: 1.08,
            fontWeight: FontWeight.w700,
            color: ink,
          ),
          headlineSmall: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.w700,
            color: ink,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.w700,
            color: ink,
          ),
          bodyLarge: TextStyle(fontSize: 16, height: 1.6, color: ink),
          bodyMedium: TextStyle(fontSize: 14, height: 1.45, color: ink),
        ),
      ),
      home: Uri.base.path.contains('/admin')
          ? const AdminScreen()
          : const LibraryScreen(),
    );
  }
}
