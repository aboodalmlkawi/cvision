import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cvision/home/ui/home_screen.dart';
import 'package:cvision/auth/ui/auth_screen.dart';

// This widget is the "gateway" that checks the user's status
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // A. Waiting situation (rare here, but just in case)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF1A1A1D),
            body: Center(child: CircularProgressIndicator(color: Colors.purpleAccent)),
          );
        }

        // B. User logged in -> Go to homepage
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // C. User not registered -> Go to the registration slide-out screen
        return const AuthScreen();
      },
    );
  }
}