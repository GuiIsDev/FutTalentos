import 'package:flutter/material.dart';
import 'telas_auth.dart';

void main() {
  runApp(const FutTalentosApp());
}

class FutTalentosApp extends StatelessWidget {
  const FutTalentosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fut Talentos',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF060D08),
        primaryColor: const Color(0xFF1FAA59),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1FAA59),
          secondary: Color(0xFF0D5C2F),
          surface: Color(0xFF0F1A12),
          onPrimary: Colors.white,
          onSurface: Color(0xFFE0E0E0),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF060D08),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Color(0xFF1FAA59)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1FAA59),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF132016),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1FAA59), width: 2),
          ),
          labelStyle: const TextStyle(color: Colors.white70),
          hintStyle: const TextStyle(color: Colors.white38),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF0A140E),
          selectedItemColor: Color(0xFF1FAA59),
          unselectedItemColor: Colors.white38,
          type: BottomNavigationBarType.fixed,
          elevation: 10,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF0F1A12),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const TelaInicial(),
    );
  }
}
