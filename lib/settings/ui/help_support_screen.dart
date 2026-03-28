import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cvision/core/constants/app_support.dart';
import 'package:cvision/core/constants/colors.dart';
import 'package:cvision/home/ui/home_screen.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  Future<void> _openSupportEmail(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: AppSupport.supportEmail,
      queryParameters: {'subject': 'CVision — Help & Support'},
    );
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
      if (!launched && context.mounted) {
        await _copyEmailFallback(context);
      }
    } catch (_) {
      if (context.mounted) await _copyEmailFallback(context);
    }
  }

  Future<void> _copyEmailFallback(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: AppSupport.supportEmail));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email copied: ${AppSupport.supportEmail}'),
          backgroundColor: AppColors.surface,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Help & Support', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: AnimatedBackground()),
          ListView(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 32),
            children: [
              _section(
                'Getting started',
                'Create an account or sign in, then tap the + button to start a new CV. You can pick a template, fill in your details, and save your work to the cloud.',
              ),
              _section(
                'Editing & saving',
                'Open any CV from your home list to edit sections such as experience, education, and skills. Changes are saved to your account so you can continue on another device.',
              ),
              _section(
                'Export & share',
                'Use preview or export options in the CV editor to generate a PDF or share your resume. This helps you apply to jobs with a consistent, ATS-friendly layout.',
              ),
              _section(
                'Account & password',
                'Update your profile photo and details from the Profile tab. If you use email sign-in, you can change your password from Settings. Use “Forgot password” on the login screen if you cannot sign in.',
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Still need help?',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppSupport.supportEmail,
                      style: const TextStyle(color: AppColors.primaryAccent, fontSize: 14, fontFamily: 'Cairo'),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _openSupportEmail(context),
                        icon: const Icon(Icons.email_outlined, color: Colors.white),
                        label: const Text('Email support', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
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

  Widget _section(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: const TextStyle(color: Colors.white70, height: 1.45, fontSize: 14, fontFamily: 'Cairo'),
            ),
          ],
        ),
      ),
    );
  }
}
