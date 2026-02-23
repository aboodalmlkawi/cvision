import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:cvision/core/constants/colors.dart';
import 'package:cvision/cv/data/models/cv_model.dart';
import 'package:cvision/cv/logic/cv_controller.dart';
import 'package:cvision/core/ui/glass_widgets.dart';

class CVSettingsScreen extends ConsumerWidget {
  final CVModel cv;

  const CVSettingsScreen({super.key, required this.cv});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF1A1A1D),
      appBar: AppBar(
        title: const Text("إعدادات الملف", style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: _StaticBackground()),

          ListView(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 20),
            children: [
              _buildGlassOption(
                context,
                icon: Icons.copy_rounded,
                title: "تكرار السيرة الذاتية",
                subtitle: "إنشاء نسخة جديدة للتعديل عليها",
                iconColor: Colors.blueAccent,
                onTap: () async {
                  final newCV = CVModel(
                    id: const Uuid().v4(),
                    userId: cv.userId,
                    templateId: cv.templateId,
                    title: "${cv.title} (نسخة)",
                    personalInfo: cv.personalInfo,
                    education: List.from(cv.education),
                    experience: List.from(cv.experience),
                    skills: List.from(cv.skills),
                    languages: List.from(cv.languages),
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );

                  try {
                    await ref.read(cvControllerProvider.notifier).saveCV(newCV);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(backgroundColor: Colors.green, content: Text("تم إنشاء نسخة جديدة بنجاح ✅", style: TextStyle(fontFamily: 'Cairo')))
                      );
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("فشل التكرار: $e")));
                    }
                  }
                },
              ),

              const SizedBox(height: 15),

              _buildGlassOption(
                context,
                icon: Icons.delete_forever_rounded,
                title: "حذف نهائي",
                subtitle: "لا يمكن التراجع عن هذا الإجراء",
                iconColor: Colors.redAccent,
                onTap: () => _confirmDelete(context, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlassOption(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color iconColor
  }) {
    return GlassContainer(
      padding: const EdgeInsets.all(5),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 11, fontFamily: 'Cairo')),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white12, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A35),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.white10)),
        title: const Text("حذف الملف؟", style: TextStyle(color: Colors.white, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        content: const Text("هل أنت متأكد من حذف هذه السيرة الذاتية؟ لن تتمكن من استعادتها.", style: TextStyle(color: Colors.white70, fontFamily: 'Cairo')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("إلغاء", style: TextStyle(color: Colors.white60))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () async {
              await ref.read(cvControllerProvider.notifier).deleteCV(cv.id);
              if (context.mounted) {
                Navigator.pop(ctx);
                Navigator.pop(context);
              }
            },
            child: const Text("حذف", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _StaticBackground extends StatelessWidget {
  const _StaticBackground();
  @override
  Widget build(BuildContext context) => Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF1A1A1D), Color(0xFF23233E)], begin: Alignment.topLeft, end: Alignment.bottomRight)));
}