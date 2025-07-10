class GameSession {
  final String id;
  final String gameMode;
  final DateTime startTime;
  final List<String> answeredQuestions;
  final Map<String, bool> answers;
  final int score;
  final int totalQuestions;
  final bool isCompleted;

  GameSession({
    required this.id,
    required this.gameMode,
    required this.startTime,
    required this.answeredQuestions,
    required this.answers,
    required this.score,
    required this.totalQuestions,
    required this.isCompleted,
  });

  double get accuracy => totalQuestions > 0 ? score / totalQuestions : 0.0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gameMode': gameMode,
      'startTime': startTime.toIso8601String(),
      'answeredQuestions': answeredQuestions,
      'answers': answers,
      'score': score,
      'totalQuestions': totalQuestions,
      'isCompleted': isCompleted,
    };
  }

  factory GameSession.fromJson(Map<String, dynamic> json) {
    return GameSession(
      id: json['id'],
      gameMode: json['gameMode'],
      startTime: DateTime.parse(json['startTime']),
      answeredQuestions: List<String>.from(json['answeredQuestions']),
      answers: Map<String, bool>.from(json['answers']),
      score: json['score'],
      totalQuestions: json['totalQuestions'],
      isCompleted: json['isCompleted'],
    );
  }
}
