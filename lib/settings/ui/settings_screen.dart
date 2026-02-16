import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cvision/core/constants/colors.dart';
import 'package:cvision/auth/ui/auth_screen.dart';
import 'package:cvision/core/ui/glass_widgets.dart'; // استدعاء الملف الجديد
// تأكد من استدعاء AnimatedBackground من ملف HomeScreen أو وضعه في ملف منفصل
import 'package:cvision/home/ui/home_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. الخلفية المتحركة
          const Positioned.fill(child: AnimatedBackground()),

          // 2. المحتوى الزجاجي
          ListView(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
            children: [
              const _SectionHeader(title: "Support"),

              GlassContainer(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildTile(Icons.support_agent, "Help & Support", () {}),
                    const Divider(height: 1, color: Colors.white10),
                    _buildTile(Icons.privacy_tip_outlined, "Privacy Policy", () {}),
                  ],
                ),
              ),

              const SizedBox(height: 25),
              const _SectionHeader(title: "Account"),

              GlassContainer(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildTile(Icons.lock_reset_outlined, "Change Password", () {}),
                    const Divider(height: 1, color: Colors.white10),
                    _buildTile(
                        Icons.logout,
                        "Logout",
                            () async {
                          await FirebaseAuth.instance.signOut();
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const AuthScreen()),
                                  (route) => false,
                            );
                          }
                        },
                        isDestructive: true
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTile(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red.withOpacity(0.1) : Colors.white.withOpacity(0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isDestructive ? Colors.redAccent : Colors.purpleAccent, size: 20),
      ),
      title: Text(title, style: TextStyle(color: isDestructive ? Colors.redAccent : Colors.white, fontFamily: 'Cairo')),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white30),
      onTap: onTap,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(color: Colors.white60, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.5),
      ),
    );
  }
}