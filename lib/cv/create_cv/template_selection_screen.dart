import 'package:flutter/material.dart';
import 'package:cvision/core/constants/colors.dart';
import 'package:cvision/cv/ui/cv_editor_screen.dart';
import 'package:cvision/core/ui/glass_widgets.dart';
import 'package:cvision/home/ui/home_screen.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cvision/cv/ui/template_cvs_screen.dart';

class TemplateSelectionScreen extends StatelessWidget {
  final bool isCreating;

  const TemplateSelectionScreen({
    super.key,
    this.isCreating = false,
  });

  @override
  Widget build(BuildContext context) {
    final templates = [
      {"name": "Classic", "color": Colors.blueGrey, "id": "classic"},
      {"name": "Modern", "color": Colors.purpleAccent, "id": "modern"},
      {"name": "Creative", "color": Colors.orangeAccent, "id": "creative"},
      {"name": "Minimal", "color": Colors.tealAccent, "id": "minimal"},
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          isCreating ? "Choose Design" : "My Templates",
          style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: isCreating
            ? IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: () => Navigator.pop(context))
            : null,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: AnimatedBackground()),

          GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 0.85,
            ),
            itemCount: templates.length,
            itemBuilder: (context, index) {
              final t = templates[index];
              final color = t["color"] as Color;

              return FadeInUp(
                delay: Duration(milliseconds: index * 100),
                child: GlassContainer(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 20)]
                        ),
                        child: Icon(
                            isCreating ? Icons.add : Icons.folder_open, // أيقونة مختلفة لكل حالة
                            size: 35, color: Colors.white
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        t["name"] as String,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Cairo'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          isCreating ? "Tap to create" : "Tap to view files",
                          style: const TextStyle(color: Colors.white54, fontSize: 10, fontFamily: 'Cairo'),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showCreateOptions(BuildContext context, String id, String name) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        margin: const EdgeInsets.all(10),
        child: GlassContainer(
          opacity: 0.2,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  "Design: $name",
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Cairo')
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.primaryAccent.withOpacity(0.5)),
                ),
                child: ListTile(
                  leading: const Icon(Icons.add_circle, color: AppColors.primaryAccent, size: 30),
                  title: const Text("Create New CV", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                  subtitle: const Text("Start from scratch", style: TextStyle(color: Colors.white54, fontSize: 12, fontFamily: 'Cairo')),
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => CVEditorScreen(templateId: id)));
                  },
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}