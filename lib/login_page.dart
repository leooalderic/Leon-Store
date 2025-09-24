import 'package:flutter/material.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  void loginUser() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("ISI DULU KINKKK!!!!"),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!email.contains("@")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Format email tidak valid!"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password minimal 6 karakter!"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Login berhasil!"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(email: email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), 
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/logo.jpg"),
              ),
              const SizedBox(height: 20),
              const Text(
                "Login",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Masuk dengan akun yang telah Kamu daftarkan.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Email",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Masukkan email",
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: const Color(0xFF2C2C2C),
                  prefixIcon: const Icon(Icons.email, color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Kata sandi",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Masukkan kata sandi",
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: const Color(0xFF2C2C2C),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.lock, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB38B59), 
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: loginUser,
                  label: const Text(
                    "Masuk",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Belum punya akun?",
                    style: TextStyle(color: Colors.white70),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Daftar",
                      style: TextStyle(
                        color: Color(0xFFB38B59),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
