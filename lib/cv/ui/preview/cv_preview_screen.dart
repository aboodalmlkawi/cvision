import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:cvision/cv/data/models/cv_model.dart';
import 'package:cvision/cv/logic/pdf_generator.dart';

class CVPreviewScreen extends StatelessWidget {
  final CVModel cv;
  final String selectedTemplate; // القالب الجديد المختار من القائمة

  const CVPreviewScreen({
    super.key,
    required this.cv,
    required this.selectedTemplate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1D),
      appBar: AppBar(
        title: Text(
          "Preview: $selectedTemplate", // للتأكد أن الاسم وصل
          style: const TextStyle(fontFamily: 'Cairo', color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PdfPreview(
        // ✅ هذا السطر يجبر الصفحة على التحديث عند تغيير القالب
        key: ValueKey(selectedTemplate),

        // ✅ هنا يكمن الحل السحري
        build: (format) {
          // 1. ننشئ نسخة جديدة تماماً من السيفي
          final tempCV = CVModel(
            id: cv.id,
            userId: cv.userId,
            templateId: selectedTemplate, // 👈 نضع القالب الجديد هنا إجبارياً
            title: cv.title,
            personalInfo: cv.personalInfo,
            education: cv.education,
            experience: cv.experience,
            skills: cv.skills,
            languages: cv.languages,
            createdAt: cv.createdAt,
            updatedAt: cv.updatedAt,
          );

          // 2. نرسل النسخة المعدلة (tempCV) إلى المولد بدلاً من القديمة (cv)
          return PdfGenerator.generate(tempCV);
        },

        allowPrinting: true,
        allowSharing: true,
        canChangeOrientation: false,
        pdfFileName: "${cv.title}_$selectedTemplate.pdf",
        loadingWidget: const Center(
          child: CircularProgressIndicator(color: Colors.tealAccent),
        ),
        scrollViewDecoration: const BoxDecoration(
          color: Color(0xFF1A1A1D),
        ),
      ),
    );
  }
}