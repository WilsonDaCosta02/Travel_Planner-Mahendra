import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';
import 'register.dart';
import 'screens/destination_screen.dart';
import 'screens/trip_screen.dart'; // Pastikan file ini ada

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel Planner',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFEF8DC),
        textTheme: GoogleFonts.poppinsTextTheme(), // Poppins everywhere
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF225B75)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Login(),
        '/register': (context) => const Register(),
        '/destinations': (context) => const DestinationScreen(),
        '/trips': (context) => const TripScreen(), // Buat ini jika belum ada
      },
    );
  }
}
