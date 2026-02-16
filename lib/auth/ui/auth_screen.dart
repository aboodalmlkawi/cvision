import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cvision/core/constants/colors.dart';
import 'package:cvision/auth/logic/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cvision/home/ui/home_screen.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool isLogin = true;
  bool _isLoading = false;

  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  // Colors
  final Color colorBg = const Color(0xFF1A1A1D);
  final Color colorOverlay1 = const Color(0xFF3B1C32);
  final Color colorOverlay2 = const Color(0xFF6A1E55);
  final Color colorAccent = const Color(0xFFA64D79);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final overlayHeight = screenHeight * 0.4;

    return Scaffold(
      backgroundColor: colorBg,
      body: Stack(
        children: [
          // 1. Input forms
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            top: isLogin ? 0 : -screenHeight,
            left: 0,
            right: 0,
            height: screenHeight * 0.6,
            child: _buildLoginForm(),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            bottom: !isLogin ? 0 : -screenHeight,
            left: 0,
            right: 0,
            height: screenHeight * 0.6,
            child: _buildSignUpForm(),
          ),

          // 2. Slider / Toggle Section
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            top: isLogin ? screenHeight * 0.6 : 0,
            left: 0,
            right: 0,
            height: overlayHeight,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorOverlay1, colorOverlay2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
                borderRadius: isLogin
                    ? const BorderRadius.vertical(top: Radius.circular(50))
                    : const BorderRadius.vertical(bottom: Radius.circular(50)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLogin ? "Don't have an account?" : "Already have an account?",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                        // Clear controllers when switching
                        _emailController.clear();
                        _passwordController.clear();
                        _nameController.clear();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      isLogin ? "Create Account" : "Login",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Cairo'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading Indicator
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator(color: Colors.purpleAccent)),
            ),
        ],
      ),
    );
  }

  // Login form
  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Welcome Back", style: TextStyle(color: colorAccent, fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
          const SizedBox(height: 10),
          const Text("Sign in to continue", style: TextStyle(color: Colors.white54, fontFamily: 'Cairo')),
          const SizedBox(height: 40),
          _customTextField("Email Address", Icons.email_outlined, _emailController),
          const SizedBox(height: 20),
          _customTextField("Password", Icons.lock_outline, _passwordController, isPassword: true),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () async {
              if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
                _showSnackBar("Please fill in all fields ⚠️", isError: true);
                return;
              }

              setState(() => _isLoading = true);

              try {
                await ref.read(authControllerProvider.notifier).login(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                );

                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                  );
                }
              } on FirebaseAuthException catch (e) {
                String message = "Login failed";
                if (e.code == 'user-not-found') {
                  message = "No user found for that email.";
                } else if (e.code == 'wrong-password') {
                  message = "Wrong password provided.";
                } else if (e.code == 'invalid-credential') {
                  message = "Email or Password is incorrect.";
                } else if (e.code == 'invalid-email') {
                  message = "The email address is badly formatted.";
                }
                if(mounted) _showSnackBar(message, isError: true);
              } catch (e) {
                if(mounted) _showSnackBar("An error occurred: ${e.toString()}", isError: true);
              } finally {
                if(mounted) setState(() => _isLoading = false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: colorBg,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Login", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Join Us", style: TextStyle(color: colorAccent, fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
          const SizedBox(height: 10),
          const Text("Create an account to get started", style: TextStyle(color: Colors.white54, fontFamily: 'Cairo')),
          const SizedBox(height: 30),
          _customTextField("Full Name", Icons.person_outline, _nameController),
          const SizedBox(height: 15),
          _customTextField("Email Address", Icons.email_outlined, _emailController),
          const SizedBox(height: 15),
          _customTextField("Password", Icons.lock_outline, _passwordController, isPassword: true),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty || _nameController.text.trim().isEmpty) {
                _showSnackBar("Please fill in all fields", isError: true);
                return;
              }
              if (_passwordController.text.length < 6) {
                _showSnackBar("Password must be at least 6 characters", isError: true);
                return;
              }

              setState(() => _isLoading = true);
              try {
                await ref.read(authControllerProvider.notifier).register(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                  fullName: _nameController.text.trim(),
                );

                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                  );
                  _showSnackBar("Account Created! Welcome 🎉");
                }
              } on FirebaseAuthException catch (e) {
                String message = "Signup failed";
                if (e.code == 'weak-password') {
                  message = "The password provided is too weak.";
                } else if (e.code == 'email-already-in-use') {
                  message = "The account already exists for that email.";
                } else if (e.code == 'invalid-email') {
                  message = "The email address is invalid.";
                }
                if(mounted) _showSnackBar(message, isError: true);
              } catch (e) {
                if(mounted) _showSnackBar("Error: ${e.toString()}", isError: true);
              } finally {
                if(mounted) setState(() => _isLoading = false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: colorBg,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }

  Widget _customTextField(String hint, IconData icon, TextEditingController controller, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38, fontFamily: 'Cairo'),
          prefixIcon: Icon(icon, color: colorAccent),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Cairo')),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}