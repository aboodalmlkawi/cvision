import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cvision/home/logic/home_controller.dart';
import 'package:cvision/home/ui/cv_card_widget.dart';
import 'package:cvision/cv/ui/cv_editor_screen.dart';

class TemplateCVsScreen extends ConsumerWidget {
  final String templateId;
  final String templateName;

  const TemplateCVsScreen({
    super.key,
    required this.templateId,
    required this.templateName
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cvsAsync = ref.watch(homeCVsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1D),
      appBar: AppBar(
        title: Text("$templateName CVs"),
        backgroundColor: Colors.transparent,
      ),
      body: cvsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err", style: TextStyle(color: Colors.red))),
        data: (allCVs) {

          print("🔍 Checking Template: Want '$templateId'");
          for (var cv in allCVs) {
            print("📄 Found File: ${cv.title}, Type: '${cv.templateId}'");
          }

          final filteredCVs = allCVs.where((cv) =>
          cv.templateId.toString().trim().toLowerCase() == templateId.toString().trim().toLowerCase()
          ).toList();

          if (filteredCVs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.folder_off, size: 60, color: Colors.grey),
                  const SizedBox(height: 20),
                  Text("No files in $templateName"),
                  const SizedBox(height: 10),
                  Text("Looking for type: '$templateId'"), // عشان تعرف شو بدور
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => CVEditorScreen(templateId: templateId)));
                    },
                    child: const Text("Create New Here"),
                  )
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: filteredCVs.length,
            itemBuilder: (ctx, i) => CVCardWidget(cv: filteredCVs[i]),
          );
        },
      ),
    );
  }
}