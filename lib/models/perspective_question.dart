enum PerspectiveType {
  self,
  other,
  observer,
}

class PerspectiveQuestion {
  final String id;
  final String scenario;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final PerspectiveType type;
  final String explanation;
  final int difficulty; // 1-3

  PerspectiveQuestion({
    required this.id,
    required this.scenario,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.type,
    required this.explanation,
    required this.difficulty,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scenario': scenario,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'type': type.name,
      'explanation': explanation,
      'difficulty': difficulty,
    };
  }

  factory PerspectiveQuestion.fromJson(Map<String, dynamic> json) {
    return PerspectiveQuestion(
      id: json['id'],
      scenario: json['scenario'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
      type: PerspectiveType.values.firstWhere(
        (e) => e.name == json['type'],
      ),
      explanation: json['explanation'],
      difficulty: json['difficulty'],
    );
  }
}
