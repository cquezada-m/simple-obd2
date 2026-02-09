enum RecommendationPriority { high, medium, low }

class Recommendation {
  final String title;
  final String description;
  final RecommendationPriority priority;
  final List<String> components;
  final String estimatedCost;

  const Recommendation({
    required this.title,
    required this.description,
    required this.priority,
    required this.components,
    required this.estimatedCost,
  });
}
