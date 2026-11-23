import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'services/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeController.instance.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeController.instance,
      builder: (context, child) {
        final colorScheme = ColorScheme.fromSeed(
          seedColor: const Color(0xFF0B4B78),
          brightness: ThemeController.instance.isDark
              ? Brightness.dark
              : Brightness.light,
        );

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeController.instance.themeMode,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: colorScheme,
            scaffoldBackgroundColor: const Color(0xFFF5F8FB),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: colorScheme,
            scaffoldBackgroundColor: const Color(0xFF101820),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
