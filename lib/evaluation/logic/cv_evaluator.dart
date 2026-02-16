import 'package:cvision/cv/data/models/cv_model.dart';

class CVEvaluator {
  static Map<String, dynamic> analyze(CVModel cv) {
    double score = 0;
    List<String> suggestions = [];
    if (cv.personalInfo.summary.length < 50) {
      score += 5;
      suggestions.add("Professional summary is too short. Try adding your core skills and career goals.");
    } else {
      score += 15;
    }
    if (cv.experience.isEmpty) {
      suggestions.add("Your CV lacks work experience. Consider adding personal projects or internships.");
    } else {
      score += 30;
      for (var exp in cv.experience) {
        if (exp.jobTitle.length < 4) {
          suggestions.add("The job title at ${exp.companyName} is too vague. Be more specific.");
        }
      }
    }
    if (cv.skills.length < 5) {
      score += 10;
      suggestions.add("You listed very few skills. ATS systems prefer seeing a diverse range of technical skills (5+).");
    } else {
      score += 20;
    }
    if (cv.personalInfo.email.contains('@') && cv.personalInfo.phone.isNotEmpty) {
      score += 20;
    } else {
      suggestions.add("Ensure your email and phone number are correct to guarantee recruiters can reach you.");
    }
    if (cv.education.isNotEmpty) {
      score += 15;
    } else {
      suggestions.add("Education section is missing. Add your degree or relevant certifications.");
    }
    final finalScore = score > 100 ? 100 : score.toInt();

    return {
      "score": finalScore,
      "suggestions": suggestions,
      "level": _getScoreLevel(finalScore),
    };
  }
  static String _getScoreLevel(int score) {
    if (score >= 85) return "Excellent 🚀";
    if (score >= 65) return "Very Good 👍";
    if (score >= 40) return "Needs Improvement ⚠️";
    return "Weak ❌";
  }
}