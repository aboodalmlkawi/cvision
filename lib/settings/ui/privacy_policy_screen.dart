import 'package:flutter/material.dart';
import 'package:cvision/core/constants/app_support.dart';
import 'package:cvision/core/constants/colors.dart';
import 'package:cvision/home/ui/home_screen.dart';

/// In-app privacy policy for CVision. Replace or extend with your legal review before production.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const String _lastUpdated = 'March 2026';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Privacy Policy', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
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
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 40),
            children: [
              const Text(
                'Last updated: $_lastUpdated',
                style: TextStyle(color: Colors.white54, fontSize: 13, fontFamily: 'Cairo'),
              ),
              const SizedBox(height: 20),
              _block(
                '1. Introduction',
                'CVision (“we”, “our”, or “us”) helps you build and manage your CV. This policy explains what information we process when you use the app and how we use it.',
              ),
              _block(
                '2. Information we collect',
                '• Account data: email address and authentication details when you register or sign in.\n'
                '• Profile data: name, photo, job title, and contact or social links you choose to add.\n'
                '• CV content: all information you enter into your resumes (employment, education, skills, etc.).\n'
                '• Technical data: may include device or app diagnostics as provided by our platform services.',
              ),
              _block(
                '3. How we use your information',
                'We use this data to provide the service: authenticate you, store and sync your CVs, display your profile, and improve reliability and security. We do not sell your personal information.',
              ),
              _block(
                '4. Storage and service providers',
                'The app uses Google Firebase (or similar cloud services) for authentication, database, and file storage. Data is processed according to Google’s terms and privacy practices in addition to this policy.',
              ),
              _block(
                '5. Retention',
                'We keep your information while your account is active and as needed to provide the service. You may delete content in the app where supported; account deletion may require contacting support.',
              ),
              _block(
                '6. Security',
                'We rely on industry-standard measures provided by our hosting and authentication providers. No method of transmission or storage is completely secure; use a strong password and protect your device.',
              ),
              _block(
                '7. Your choices',
                'You can update profile and CV data in the app. You may sign out at any time. For questions about access, correction, or deletion of your data, contact us at the email below.',
              ),
              _block(
                '8. Children',
                'CVision is not directed at children under 13 (or the minimum age required in your region). We do not knowingly collect personal information from children.',
              ),
              _block(
                '9. Changes',
                'We may update this policy from time to time. The “Last updated” date will change when we do. Continued use of the app after changes means you accept the updated policy.',
              ),
              _block(
                '10. Contact',
                'Questions about privacy: ${AppSupport.supportEmail}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _block(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primaryAccent,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 8),
          SelectableText(
            body,
            style: const TextStyle(color: Colors.white70, height: 1.5, fontSize: 14, fontFamily: 'Cairo'),
          ),
        ],
      ),
    );
  }
}
