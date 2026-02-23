import 'package:flutter/material.dart';
import 'package:cvision/cv/ui/template_cvs_screen.dart';

class TemplateSelectionScreen extends StatelessWidget {
  const TemplateSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1D),
      appBar: AppBar(
        title: const Text("My Templates", style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [
            _buildTemplateCard(context, "Modern", "modern", Colors.purpleAccent),
            _buildTemplateCard(context, "Classic", "classic", Colors.blueGrey),
            _buildTemplateCard(context, "Creative", "creative", Colors.orangeAccent),
            _buildTemplateCard(context, "Minimal", "minimal", Colors.tealAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateCard(BuildContext context, String name, String id, Color color) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TemplateCVsScreen(templateId: id, templateName: name),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A35),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 20)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.folder_copy_outlined, size: 30, color: color),
            ),
            const SizedBox(height: 15),
            Text(name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
            const SizedBox(height: 5),
            const Text("Tap to view files", style: TextStyle(color: Colors.white38, fontSize: 10, fontFamily: 'Cairo')),
          ],
        ),
      ),
    );
  }
}