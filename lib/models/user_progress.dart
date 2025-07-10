class UserProgress {
  final int points;
  final List<String> badges;
  final List<String> completedQuests;
  final int level;
  final double echoScore;

  UserProgress({
    required this.points,
    required this.badges,
    required this.completedQuests,
    required this.level,
    required this.echoScore,
  });

  factory UserProgress.initial() => UserProgress(
    points: 0,
    badges: [],
    completedQuests: [],
    level: 1,
    echoScore: 0.0,
  );

  factory UserProgress.fromMap(Map<String, dynamic> map) => UserProgress(
    points: map['points'] ?? 0,
    badges: List<String>.from(map['badges'] ?? []),
    completedQuests: List<String>.from(map['completedQuests'] ?? []),
    level: map['level'] ?? 1,
    echoScore: (map['echoScore'] ?? 0.0).toDouble(),
  );

  Map<String, dynamic> toMap() => {
    'points': points,
    'badges': badges,
    'completedQuests': completedQuests,
    'level': level,
    'echoScore': echoScore,
  };

  UserProgress copyWith({
    int? points,
    List<String>? badges,
    List<String>? completedQuests,
    int? level,
    double? echoScore,
  }) => UserProgress(
    points: points ?? this.points,
    badges: badges ?? this.badges,
    completedQuests: completedQuests ?? this.completedQuests,
    level: level ?? this.level,
    echoScore: echoScore ?? this.echoScore,
  );
}
