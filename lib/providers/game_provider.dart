import 'package:flutter/foundation.dart';
import '../models/perspective_question.dart';
import '../models/game_session.dart';
import '../services/question_service.dart';

class GameProvider extends ChangeNotifier {
  GameSession? _currentSession;
  PerspectiveQuestion? _currentQuestion;
  List<PerspectiveQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  bool _isLoading = false;
  String? _selectedAnswer;
  bool _hasAnswered = false;
  
  final QuestionService _questionService = QuestionService();

  // Getters
  GameSession? get currentSession => _currentSession;
  PerspectiveQuestion? get currentQuestion => _currentQuestion;
  List<PerspectiveQuestion> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  bool get isLoading => _isLoading;
  String? get selectedAnswer => _selectedAnswer;
  bool get hasAnswered => _hasAnswered;
  bool get hasNextQuestion => _currentQuestionIndex < _questions.length - 1;
  bool get isSessionComplete => _currentSession?.isCompleted ?? false;

  Future<void> startSession(String gameMode, {int? difficulty}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _questions = await _questionService.getQuestions(
        gameMode: gameMode,
        difficulty: difficulty,
      );
      
      _currentSession = GameSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        gameMode: gameMode,
        startTime: DateTime.now(),
        answeredQuestions: [],
        answers: {},
        score: 0,
        totalQuestions: _questions.length,
        isCompleted: false,
      );
      
      _currentQuestionIndex = 0;
      _currentQuestion = _questions.isNotEmpty ? _questions[0] : null;
      _selectedAnswer = null;
      _hasAnswered = false;
    } catch (e) {
      debugPrint('Error starting session: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectAnswer(String answer) {
    if (!_hasAnswered) {
      _selectedAnswer = answer;
      notifyListeners();
    }
  }

  bool submitAnswer() {
    if (_selectedAnswer == null || _hasAnswered || _currentQuestion == null) {
      return false;
    }

    _hasAnswered = true;
    
    // Check if answer is correct
    final isCorrect = _currentQuestion!.options.indexOf(_selectedAnswer!) == 
                     _currentQuestion!.correctAnswer;
    
    // Update session
    _currentSession = GameSession(
      id: _currentSession!.id,
      gameMode: _currentSession!.gameMode,
      startTime: _currentSession!.startTime,
      answeredQuestions: [..._currentSession!.answeredQuestions, _currentQuestion!.id],
      answers: {..._currentSession!.answers, _currentQuestion!.id: isCorrect},
      score: _currentSession!.score + (isCorrect ? 1 : 0),
      totalQuestions: _currentSession!.totalQuestions,
      isCompleted: _currentSession!.isCompleted,
    );
    
    notifyListeners();
    return isCorrect;
  }

  void nextQuestion() {
    if (hasNextQuestion) {
      _currentQuestionIndex++;
      _currentQuestion = _questions[_currentQuestionIndex];
      _selectedAnswer = null;
      _hasAnswered = false;
    } else {
      // Complete session
      _currentSession = GameSession(
        id: _currentSession!.id,
        gameMode: _currentSession!.gameMode,
        startTime: _currentSession!.startTime,
        answeredQuestions: _currentSession!.answeredQuestions,
        answers: _currentSession!.answers,
        score: _currentSession!.score,
        totalQuestions: _currentSession!.totalQuestions,
        isCompleted: true,
      );
    }
    notifyListeners();
  }

  void resetSession() {
    _currentSession = null;
    _currentQuestion = null;
    _questions = [];
    _currentQuestionIndex = 0;
    _selectedAnswer = null;
    _hasAnswered = false;
    notifyListeners();
  }
}
