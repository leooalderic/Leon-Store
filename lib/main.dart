import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'splash_screen.dart';
import 'home_page.dart';
import 'register_page.dart'; // pastikan kamu sudah buat file ini

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cek apakah user sudah login
  final prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leon Store',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,

      // SplashScreen akan tetap jadi halaman awal
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) {
          // Ambil email dari SharedPreferences
          return FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              final prefs = snapshot.data!;
              final email = prefs.getString('email') ?? 'Guest';
              return HomePage(email: email);
            },
          );
        },
      },
    );
  }
}
