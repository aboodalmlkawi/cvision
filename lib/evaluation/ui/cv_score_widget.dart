import 'package:flutter/material.dart';
import 'package:cvision/core/constants/colors.dart';
import '../logic/cv_evaluator.dart';
import 'package:cvision/cv/data/models/cv_model.dart';

class CVScoreWidget extends StatelessWidget {
  final CVModel cv;

  const CVScoreWidget({super.key, required this.cv});

  @override
  Widget build(BuildContext context) {
    final result = CVEvaluator.analyze(cv);
    final double score = result['score'];
    final List<String> suggestions = result['suggestions'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getScoreColor(score).withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("قوة الملف (ATS Score)", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  Text(result['level'], style: TextStyle(color: _getScoreColor(score), fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 8,
                    color: _getScoreColor(score),
                    backgroundColor: Colors.white10,
                  ),
                  Text("${score.toInt()}%", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
          if (suggestions.isNotEmpty) ...[
            const Divider(height: 30, color: Colors.white10),
            Column(
              children: suggestions.take(2).map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 18),
                    const SizedBox(width: 10),
                    Expanded(child: Text(s, style: const TextStyle(color: Colors.white60, fontSize: 12))),
                  ],
                ),
              )).toList(),
            )
          ]
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 85) return Colors.greenAccent;
    if (score >= 65) return Colors.blueAccent;
    if (score >= 40) return Colors.orangeAccent;
    return Colors.redAccent;
  }
}