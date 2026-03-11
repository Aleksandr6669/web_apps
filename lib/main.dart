import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calorie Tracker',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      home: const HomeScreen(),
    );
  }
}

ThemeData _buildTheme(Brightness brightness) {
  final bool isLight = brightness == Brightness.light;

  const Color primaryColor = Color(0xFF00C753);
  final Color background = isLight ? const Color(0xFFF5F8F7) : const Color(0xFF0F2317);
  const Color onPrimary = Colors.white;
  final Color textColor = isLight ? const Color(0xFF0F2317) : Colors.white;
  final Color subtleTextColor = isLight ? Colors.grey.shade600 : Colors.grey.shade400;
  final Color cardColor = isLight ? Colors.white : const Color(0xFF1C1C1E);


  final baseTheme = ThemeData(
    brightness: brightness,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: background,
    useMaterial3: true,
  );

  return baseTheme.copyWith(
    colorScheme: baseTheme.colorScheme.copyWith(
      primary: primaryColor,
      onPrimary: onPrimary,
      surface: cardColor,
      onSurface: textColor,
    ),
    textTheme: GoogleFonts.manropeTextTheme(baseTheme.textTheme).apply(
      bodyColor: textColor,
      displayColor: textColor,
    ).copyWith(
      displayLarge: const TextStyle(fontWeight: FontWeight.w800),
      displayMedium: const TextStyle(fontWeight: FontWeight.w800),
      displaySmall: const TextStyle(fontWeight: FontWeight.w800),
      headlineLarge: const TextStyle(fontWeight: FontWeight.w800),
      headlineMedium: const TextStyle(fontWeight: FontWeight.bold),
      headlineSmall: const TextStyle(fontWeight: FontWeight.bold),
      titleLarge: const TextStyle(fontWeight: FontWeight.bold),
      titleMedium: const TextStyle(fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: subtleTextColor),
      bodyMedium: TextStyle(color: subtleTextColor),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: textColor,
      titleTextStyle: baseTheme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: textColor),
      centerTitle: true,
    ),
     elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        elevation: 0,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: cardColor.withOpacity(0.8),
      selectedItemColor: primaryColor,
      unselectedItemColor: subtleTextColor,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
    ),
  );
}
