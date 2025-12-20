import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanrio_characters_app/screens/landing_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class AppColors {
  static const Color primaryBackground = Color(0xFFF8F6F3);
  static const Color secondaryBackground = Color(0xFFF5E6D3);
  static const Color accentLavender = Color(0xFFE8D5F2);
  static const Color accentMint = Color(0xFFD4F1E8);
  static const Color textDark = Color(0xFF2C2C2C);
  static const Color textMuted = Color(0xFF7A7A7A);
  static const Color cardBackground = Color(0xFFFFFBF8);
  static const Color shadowColor = Color(0x1A000000);

  static bool _isDarkColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance < 0.5;
  }

  static Color getAppBarTextColor(Color backgroundColor) {
    return _isDarkColor(backgroundColor) ? Colors.white : textDark;
  }

  static Color getAppBarIconColor(Color backgroundColor) {
    return _isDarkColor(backgroundColor) ? Colors.white : textDark;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sanrio Characters App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.primaryBackground,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.accentMint,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.getAppBarTextColor(AppColors.accentMint),
          ),
          iconTheme: IconThemeData(
            color: AppColors.getAppBarIconColor(AppColors.accentMint),
          ),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.light().textTheme,
        ).apply(
          bodyColor: AppColors.textDark,
          displayColor: AppColors.textDark,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentMint,
            foregroundColor: AppColors.textDark,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.cardBackground,
          elevation: 1,
          shadowColor: AppColors.shadowColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: const LandingScreen(),
    );
  }
}
