import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cvision/core/constants/colors.dart';
import 'package:cvision/home/logic/home_controller.dart';
import 'package:cvision/home/ui/cv_card_widget.dart';

class TemplateDetailScreen extends ConsumerWidget {
  final String templateId;
  final String templateName;
  final Color templateColor;

  const TemplateDetailScreen({
    super.key,
    required this.templateId,
    required this.templateName,
    required this.templateColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cvsAsync = ref.watch(homeCVsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
            "$templateName Folder",
            style: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                color: Colors.white
            )
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: cvsAsync.when(
        data: (allCVs) {
          final filteredCVs = allCVs.where((cv) {
            final fileType = cv.templateId.toString().trim().toLowerCase();
            final targetType = templateId.toString().trim().toLowerCase();
            return fileType == targetType;
          }).toList();
          if (filteredCVs.isEmpty) {
            return Center(
              child: FadeIn(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: templateColor.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                          Icons.folder_open_rounded,
                          size: 80,
                          color: templateColor.withOpacity(0.5)
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                        "No $templateName CVs found",
                        style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 16,
                            fontFamily: 'Cairo'
                        )
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Any CV you create with this template will appear here.",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.2),
                          fontSize: 12,
                          fontFamily: 'Cairo'
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            itemCount: filteredCVs.length,
            itemBuilder: (context, index) {
              return FadeInUp(
                duration: const Duration(milliseconds: 400),
                delay: Duration(milliseconds: index * 100),
                child: CVCardWidget(cv: filteredCVs[index]),
              );
            },
          );
        },
        loading: () => Center(
            child: CircularProgressIndicator(
                color: templateColor,
                strokeWidth: 2
            )
        ),
        error: (err, stack) => Center(
            child: Text(
                "Error loading files",
                style: TextStyle(color: Colors.redAccent.withOpacity(0.8), fontFamily: 'Cairo')
            )
        ),
      ),
    );
  }
}