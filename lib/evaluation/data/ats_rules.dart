class AtsRules {
  // (Action Verbs)
  static const List<String> actionVerbs = [
    "developed", "managed", "led", "created", "designed", "implemented",
    "improved", "analyzed", "optimized", "collaborated", "achieved"
  ];

  static const Map<String, int> sectionWeights = {
    'contact_info': 20,
    'summary': 15,
    'experience': 30,
    'skills': 20,
    'education': 15,
  };

  static const int minSummaryLength = 50;
  static const int minExperienceDescLength = 20;
}