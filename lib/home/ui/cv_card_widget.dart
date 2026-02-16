import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:cvision/cv/data/models/cv_model.dart';
import 'package:cvision/cv/logic/cv_controller.dart';
import 'package:cvision/core/ui/glass_widgets.dart';
import 'package:cvision/cv/logic/pdf_generator.dart';
import 'package:cvision/cv/ui/preview/cv_preview_screen.dart';
import 'package:cvision/cv/ui/cv_editor_screen.dart';
import 'package:cvision/evaluation/logic/cv_evaluator.dart';

class CVCardWidget extends ConsumerWidget {
  final CVModel cv;
  const CVCardWidget({super.key, required this.cv});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColor = _getTemplateColor(cv.templateId);

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GlassContainer(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: themeColor.withOpacity(0.3)),
                  ),
                  child: Icon(Icons.description_rounded, color: themeColor, size: 24),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cv.title.isEmpty ? "Untitled CV" : cv.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Cairo'
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Updated: ${DateFormat('yyyy-MM-dd').format(cv.updatedAt)}",
                        style: const TextStyle(color: Colors.white38, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                _buildActionIcon(Icons.edit_outlined, Colors.blueAccent, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => CVEditorScreen(cvToEdit: cv)));
                }),
                _buildActionIcon(Icons.tune_outlined, const Color(0xFF66F7D0), () {
                  _showDesignSelectionSheet(context, cv);
                }),
                _buildActionIcon(Icons.analytics_outlined, Colors.amberAccent, () {
                  _showAnalysisDialog(context, cv);
                }),
                _buildActionIcon(Icons.delete_outline, Colors.redAccent, () {
                  _confirmDelete(context, ref, cv.id);
                }),
              ],
            ),
            const SizedBox(height: 15),
            _buildLinearProgress(themeColor),
          ],
        ),
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, Color color, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: color, size: 22),
      onPressed: onTap,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildLinearProgress(Color color) {
    return Row(
      children: [
        const Text("100%", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 1.0,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 5,
            ),
          ),
        ),
      ],
    );
  }

  void _showAnalysisDialog(BuildContext context, CVModel cv) {
    final analysis = CVEvaluator.analyze(cv);
    final int score = analysis['score'];
    final String level = analysis['level'];
    final List<String> suggestions = analysis['suggestions'];
    Color scoreColor = score >= 85 ? const Color(0xFF66F7D0) : (score >= 50 ? Colors.orangeAccent : Colors.redAccent);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C).withOpacity(0.95),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white.withOpacity(0.1))
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: scoreColor, width: 4),
                color: scoreColor.withOpacity(0.1),
              ),
              child: Text(
                "$score%",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: scoreColor, fontFamily: 'Cairo'),
              ),
            ),
            const SizedBox(height: 15),

            Text(level, style: TextStyle(color: scoreColor, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
            const SizedBox(height: 20),

            if (suggestions.isNotEmpty) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Improvements Needed:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(
                  child: Column(
                    children: suggestions.map((s) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline, color: Colors.amber, size: 16),
                          const SizedBox(width: 8),
                          Expanded(child: Text(s, style: const TextStyle(color: Colors.white70, fontSize: 12))),
                        ],
                      ),
                    )).toList(),
                  ),
                ),
              ),
            ] else ...[
              const Text("Great Job! Your CV is ready. 🚀", style: TextStyle(color: Colors.white70)),
            ]
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Close", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  void _showDesignSelectionSheet(BuildContext context, CVModel cv) {
    final List<Map<String, dynamic>> styles = [
      {'name': 'Classic', 'icon': Icons.article_outlined, 'color': Colors.blueGrey},
      {'name': 'Modern', 'icon': Icons.dashboard_customize_outlined, 'color': Colors.purpleAccent},
      {'name': 'Creative', 'icon': Icons.brush_outlined, 'color': Colors.orangeAccent},
      {'name': 'Minimal', 'icon': Icons.crop_square_outlined, 'color': Colors.tealAccent},
    ];

    String tempSelectedStyle = cv.templateId.isNotEmpty ? _capitalize(cv.templateId) : 'Modern';

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
                  const SizedBox(height: 25),
                  const Text("Choose Design Style", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: styles.map((style) {
                      final isSelected = tempSelectedStyle.toLowerCase() == style['name'].toString().toLowerCase();
                      final color = style['color'] as Color;

                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            tempSelectedStyle = style['name'];
                          });
                        },
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: isSelected ? color.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: isSelected ? color : Colors.white10,
                                    width: isSelected ? 2 : 1
                                ),
                              ),
                              child: Icon(style['icon'], color: isSelected ? color : Colors.white38, size: 28),
                            ),
                            const SizedBox(height: 10),
                            Text(style['name'], style: TextStyle(color: isSelected ? Colors.white : Colors.white38, fontSize: 12)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 40),

                  Row(
                    children: [
                      // Preview
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white24),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => CVPreviewScreen(cv: cv, selectedTemplate: tempSelectedStyle),
                            ));
                          },
                          icon: const Icon(Icons.visibility_outlined, size: 18),
                          label: const Text("Preview", style: TextStyle(fontFamily: 'Cairo')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Edit
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white24),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.push(context, MaterialPageRoute(builder: (_) => CVEditorScreen(cvToEdit: cv)));
                          },
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: const Text("Edit", style: TextStyle(fontFamily: 'Cairo')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Share
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF66F7D0),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: () async {
                            final tempCV = _createTempCV(cv, tempSelectedStyle);
                            final pdfBytes = await PdfGenerator.generate(tempCV);
                            await Printing.sharePdf(bytes: pdfBytes, filename: "${cv.title}_${tempSelectedStyle}.pdf");
                          },
                          icon: const Icon(Icons.share_outlined, size: 18),
                          label: const Text("Share", style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  CVModel _createTempCV(CVModel original, String newTemplateId) {
    return CVModel(
      id: original.id,
      userId: original.userId,
      templateId: newTemplateId.toLowerCase(),
      title: original.title,
      personalInfo: original.personalInfo,
      education: original.education,
      experience: original.experience,
      skills: original.skills,
      languages: original.languages,
      createdAt: original.createdAt,
      updatedAt: original.updatedAt,
    );
  }

  Color _getTemplateColor(String id) {
    switch (id.toLowerCase().trim()) {
      case 'modern': return Colors.purpleAccent;
      case 'minimal': return Colors.tealAccent;
      case 'creative': return Colors.orangeAccent;
      case 'classic': return Colors.blueGrey;
      default: return Colors.blueAccent;
    }
  }

  String _capitalize(String s) => s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : '';

  void _confirmDelete(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A35),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.white10)),
        title: const Text("Delete CV?", style: TextStyle(color: Colors.white, fontFamily: 'Cairo')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel", style: TextStyle(color: Colors.white60))),
          TextButton(
            onPressed: () {
              ref.read(cvControllerProvider.notifier).deleteCV(id);
              Navigator.pop(ctx);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}