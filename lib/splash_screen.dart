import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            children: [
              
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/splash.jpg', 
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'LEON STORE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'by Leony Andika Triwicaksono_022',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
