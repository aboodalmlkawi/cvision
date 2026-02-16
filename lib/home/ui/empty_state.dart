import 'package:flutter/material.dart';
import 'package:cvision/core/constants/colors.dart';

class EmptyState extends StatelessWidget {
  final VoidCallback onCreate;

  const EmptyState({super.key, required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryAccent.withOpacity(0.3), width: 2),
            ),
            child: Icon(Icons.folder_open_rounded, size: 60, color: Colors.white.withOpacity(0.5)),
          ),
          const SizedBox(height: 20),
          const Text(
            "لا توجد ملفات محفوظة بعد",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
          ),
          const SizedBox(height: 10),
          const Text(
            "ابدأ بإنشاء سيرتك الذاتية الأولى الآن",
            style: TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Cairo'),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: onCreate,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryAccent,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text("إنشاء جديد", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }
}