class SkillGapAnalyzer {
  static const Map<String, List<String>> _roleRequirements = {
    "flutter": ["Dart", "Firebase", "Riverpod", "Clean Architecture", "Unit Testing", "Git"],
    "android": ["Kotlin", "Jetpack Compose", "Retrofit", "MVVM", "Coroutines"],
    "ios": ["Swift", "SwiftUI", "Combine", "Core Data", "CocoaPods"],
    "python": ["Django", "FastAPI", "Pandas", "PostgreSQL", "Docker"],
    "data": ["SQL", "Power BI", "Tableau", "Python", "Statistics", "Excel"],
    "frontend": ["React", "TypeScript", "Tailwind CSS", "Redux", "Next.js"],
    "backend": ["Node.js", "Express", "MongoDB", "Redis", "Microservices"],
    "ai": ["Machine Learning", "Deep Learning", "PyTorch", "TensorFlow", "NLP"],
  };


  static List<String> analyze(String jobTitle, List<String> currentSkills) {
    Set<String> missingSkills = {};
    String normalizedTitle = jobTitle.toLowerCase().trim();

    _roleRequirements.forEach((key, requiredSkills) {
      if (normalizedTitle.contains(key)) {
        for (String skill in requiredSkills) {
          if (!_containsSkill(currentSkills, skill)) {
            missingSkills.add(skill);
          }
        }
      }
    });

    if (missingSkills.isEmpty) {
      return suggestSkills(currentSkills);
    }

    return missingSkills.toList();
  }

  static List<String> suggestSkills(List<String> currentSkills) {
    Set<String> suggestions = {};

    for (String skill in currentSkills) {
      String normalizedUserSkill = skill.toLowerCase().trim();

      _roleRequirements.forEach((key, skillsList) {
        if (normalizedUserSkill.contains(key)) {
          for (String s in skillsList) {
            if (!_containsSkill(currentSkills, s)) {
              suggestions.add(s);
            }
          }
        }
      });
    }
    return suggestions.toList();
  }

  static bool _containsSkill(List<String> list, String skill) {
    return list.any((s) => s.toLowerCase().trim() == skill.toLowerCase().trim());
  }
}