import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/player_progress.dart';
import '../models/game_session.dart';

class ProgressProvider extends ChangeNotifier {
  PlayerProgress _progress = PlayerProgress.initial();
  bool _isLoading = false;

  PlayerProgress get progress => _progress;
  bool get isLoading => _isLoading;

  Future<void> loadProgress() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final progressJson = prefs.getString('player_progress');
      
      if (progressJson != null) {
        final progressMap = Map<String, dynamic>.from(
          await compute(_parseJson, progressJson)
        );
        _progress = PlayerProgress.fromJson(progressMap);
      }
    } catch (e) {
      debugPrint('Error loading progress: $e');
      _progress = PlayerProgress.initial();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progressJson = await compute(_stringifyJson, _progress.toJson());
      await prefs.setString('player_progress', progressJson);
    } catch (e) {
      debugPrint('Error saving progress: $e');
    }
  }

  void updateProgressFromSession(GameSession session) {
    final experienceGained = session.score * 10;
    final newExperience = _progress.experiencePoints + experienceGained;
    final newLevel = (newExperience / 100).floor() + 1;
    
    // Update category scores
    final newCategoryScores = Map<String, int>.from(_progress.categoryScores);
    newCategoryScores[session.gameMode] = 
        (newCategoryScores[session.gameMode] ?? 0) + session.score;

    // Check for new achievements
    final newAchievements = List<String>.from(_progress.unlockedAchievements);
    _checkAchievements(session, newAchievements);

    _progress = _progress.copyWith(
      totalScore: _progress.totalScore + session.score,
      questionsAnswered: _progress.questionsAnswered + session.totalQuestions,
      correctAnswers: _progress.correctAnswers + session.score,
      categoryScores: newCategoryScores,
      unlockedAchievements: newAchievements,
      currentLevel: newLevel,
      experiencePoints: newExperience,
      lastPlayed: DateTime.now(),
    );

    saveProgress();
    notifyListeners();
  }

  void _checkAchievements(GameSession session, List<String> achievements) {
    // First game achievement
    if (_progress.questionsAnswered == 0 && 
        !achievements.contains('first_game')) {
      achievements.add('first_game');
    }

    // Perfect score achievement
    if (session.accuracy == 1.0 && 
        !achievements.contains('perfect_score')) {
      achievements.add('perfect_score');
    }

    // 10 games achievement
    if (_progress.questionsAnswered >= 100 && 
        !achievements.contains('ten_games')) {
      achievements.add('ten_games');
    }

    // High accuracy achievement
    if (_progress.accuracy >= 0.8 && 
        _progress.questionsAnswered >= 50 &&
        !achievements.contains('high_accuracy')) {
      achievements.add('high_accuracy');
    }

    // Level 5 achievement
    if (_progress.currentLevel >= 5 && 
        !achievements.contains('level_five')) {
      achievements.add('level_five');
    }
  }

  void resetProgress() {
    _progress = PlayerProgress.initial();
    saveProgress();
    notifyListeners();
  }
}

// Helper functions for compute
Map<String, dynamic> _parseJson(String jsonString) {
  return Map<String, dynamic>.from(
    jsonDecode(jsonString)
  );
}

String _stringifyJson(Map<String, dynamic> map) {
  return jsonEncode(map);
}
