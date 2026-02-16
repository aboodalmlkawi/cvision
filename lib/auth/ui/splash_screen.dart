import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cvision/core/constants/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.surface.withOpacity(0.8),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // The app logo with a pulse movement
            ZoomIn(
              duration: const Duration(seconds: 1),
              child: Pulse(
                infinite: true,
                child: Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'assets/logo.png',
                    width: 150,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.description_rounded,
                      size: 100,
                      color: AppColors.primaryAccent,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // The app's name is in an upward movement
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              child: const Text(
                "CVision",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 10),
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: const Text(
                "Your professional future starts here",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white60,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            const SizedBox(height: 50),
            // Load indicator
            FadeIn(
              delay: const Duration(seconds: 2),
              child: const SizedBox(
                width: 40,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white10,
                  color: AppColors.primaryAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}