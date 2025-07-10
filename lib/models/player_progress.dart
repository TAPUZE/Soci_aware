class PlayerProgress {
  final int totalScore;
  final int questionsAnswered;
  final int correctAnswers;
  final Map<String, int> categoryScores; // category -> score
  final List<String> unlockedAchievements;
  final int currentLevel;
  final int experiencePoints;
  final DateTime lastPlayed;

  PlayerProgress({
    required this.totalScore,
    required this.questionsAnswered,
    required this.correctAnswers,
    required this.categoryScores,
    required this.unlockedAchievements,
    required this.currentLevel,
    required this.experiencePoints,
    required this.lastPlayed,
  });

  double get accuracy => questionsAnswered > 0 ? correctAnswers / questionsAnswered : 0.0;

  int get experienceToNextLevel => ((currentLevel + 1) * 100) - experiencePoints;

  Map<String, dynamic> toJson() {
    return {
      'totalScore': totalScore,
      'questionsAnswered': questionsAnswered,
      'correctAnswers': correctAnswers,
      'categoryScores': categoryScores,
      'unlockedAchievements': unlockedAchievements,
      'currentLevel': currentLevel,
      'experiencePoints': experiencePoints,
      'lastPlayed': lastPlayed.toIso8601String(),
    };
  }

  factory PlayerProgress.fromJson(Map<String, dynamic> json) {
    return PlayerProgress(
      totalScore: json['totalScore'],
      questionsAnswered: json['questionsAnswered'],
      correctAnswers: json['correctAnswers'],
      categoryScores: Map<String, int>.from(json['categoryScores']),
      unlockedAchievements: List<String>.from(json['unlockedAchievements']),
      currentLevel: json['currentLevel'],
      experiencePoints: json['experiencePoints'],
      lastPlayed: DateTime.parse(json['lastPlayed']),
    );
  }

  PlayerProgress copyWith({
    int? totalScore,
    int? questionsAnswered,
    int? correctAnswers,
    Map<String, int>? categoryScores,
    List<String>? unlockedAchievements,
    int? currentLevel,
    int? experiencePoints,
    DateTime? lastPlayed,
  }) {
    return PlayerProgress(
      totalScore: totalScore ?? this.totalScore,
      questionsAnswered: questionsAnswered ?? this.questionsAnswered,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      categoryScores: categoryScores ?? this.categoryScores,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      currentLevel: currentLevel ?? this.currentLevel,
      experiencePoints: experiencePoints ?? this.experiencePoints,
      lastPlayed: lastPlayed ?? this.lastPlayed,
    );
  }

  static PlayerProgress initial() {
    return PlayerProgress(
      totalScore: 0,
      questionsAnswered: 0,
      correctAnswers: 0,
      categoryScores: {},
      unlockedAchievements: [],
      currentLevel: 1,
      experiencePoints: 0,
      lastPlayed: DateTime.now(),
    );
  }
}
