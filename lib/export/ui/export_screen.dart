import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:cvision/core/constants/colors.dart';
import 'package:cvision/cv/data/models/cv_model.dart';
import '../pdf/cv_pdf_generator.dart';
import '../share/share_service.dart';

class ExportScreen extends StatefulWidget {
  final CVModel cv;

  const ExportScreen({super.key, required this.cv});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  String _selectedTemplate = 'modern';
  bool _isGenerating = false;

  final Map<String, String> _templates = {
    'modern': 'حديث (Modern)',
    'classic': 'كلاسيكي (Classic)',
    'creative': 'إبداعي (Creative)',
    'minimal': 'بسيط (Minimal)',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("تصدير السيرة الذاتية"),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.primaryAccent),
            onPressed: () async {
              setState(() => _isGenerating = true);
              final bytes = await CVPdfGenerator.generate(widget.cv, templateType: _selectedTemplate);
              await ShareService.sharePdf(bytes, "CV_${widget.cv.personalInfo.fullName}");
              setState(() => _isGenerating = false);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: AppColors.surface,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _templates.entries.map((entry) {
                final isSelected = _selectedTemplate == entry.key;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(entry.value),
                    selected: isSelected,
                    selectedColor: AppColors.primaryAccent,
                    backgroundColor: Colors.grey[800],
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey),
                    onSelected: (bool selected) {
                      if (selected) {
                        setState(() => _selectedTemplate = entry.key);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: PdfPreview(
              build: (format) => CVPdfGenerator.generate(widget.cv, templateType: _selectedTemplate),
              useActions: false,
              loadingWidget: const Center(child: CircularProgressIndicator(color: AppColors.primaryAccent)),
              scrollViewDecoration: BoxDecoration(color: AppColors.background),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.surface,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.print),
                    label: const Text("طباعة"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[700]),
                    onPressed: () async {
                      final bytes = await CVPdfGenerator.generate(widget.cv, templateType: _selectedTemplate);
                      await Printing.layoutPdf(onLayout: (_) => bytes);
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.download),
                    label: const Text("تصدير PDF"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryAccent),
                    onPressed: () async {
                      final bytes = await CVPdfGenerator.generate(widget.cv, templateType: _selectedTemplate);
                      await ShareService.sharePdf(bytes, "CV_${widget.cv.personalInfo.fullName}");
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}