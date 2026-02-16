import 'package:flutter/material.dart';
import 'package:cvision/core/constants/colors.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive; // Is the action deleted? (Highlighted in red)

  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.confirmText = "تأكيد",
    this.cancelText = "إلغاء",
    this.onCancel,
    this.isDestructive = false,
  });

  // Help function for quickly displaying the dialogue
  static void show(BuildContext context, {
    required String title,
    required String content,
    required VoidCallback onConfirm,
    bool isDestructive = false,
  }) {
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: title,
        content: content,
        onConfirm: onConfirm,
        isDestructive: isDestructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),

      content: Text(
        content,
        style: const TextStyle(
          color: Colors.white70,
          fontFamily: 'Cairo',
        ),
      ),

      actions: [
        // Cancel button
        TextButton(
          onPressed: () {
            if (onCancel != null) onCancel!();
            Navigator.of(context).pop();
          },
          child: Text(
            cancelText,
            style: const TextStyle(color: Colors.grey, fontFamily: 'Cairo'),
          ),
        ),

        // Confirm button
        ElevatedButton(
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isDestructive ? AppColors.error : AppColors.primaryAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            confirmText,
            style: const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
          ),
        ),
      ],
    );
  }
}