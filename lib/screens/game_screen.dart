import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/progress_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/question_card.dart';
import '../widgets/answer_option.dart';
import '../widgets/progress_indicator_widget.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  final String gameMode;
  final int? difficulty;

  const GameScreen({
    Key? key,
    required this.gameMode,
    this.difficulty,
  }) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Start the game
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameProvider>().startSession(
        widget.gameMode,
        difficulty: widget.difficulty,
      );
      _slideController.forward();
      _scaleController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _showExitDialog(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getGameModeTitle()),
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            Consumer<GameProvider>(
              builder: (context, gameProvider, child) {
                if (gameProvider.currentSession != null) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Center(
                      child: Text(
                        '${gameProvider.currentSession!.score}/${gameProvider.currentSession!.totalQuestions}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: Consumer<GameProvider>(
          builder: (context, gameProvider, child) {
            if (gameProvider.isLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading questions...'),
                  ],
                ),
              );
            }

            if (gameProvider.isSessionComplete) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _navigateToResults();
              });
              return const Center(child: CircularProgressIndicator());
            }

            if (gameProvider.currentQuestion == null) {
              return const Center(
                child: Text('No questions available'),
              );
            }

            return Column(
              children: [
                // Progress indicator
                ProgressIndicatorWidget(
                  current: gameProvider.currentQuestionIndex + 1,
                  total: gameProvider.questions.length,
                ),
                Expanded(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: QuestionCard(
                                question: gameProvider.currentQuestion!,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildAnswerOptions(gameProvider),
                            const SizedBox(height: 16),
                            _buildActionButton(gameProvider),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnswerOptions(GameProvider gameProvider) {
    return Column(
      children: gameProvider.currentQuestion!.options
          .asMap()
          .entries
          .map((entry) {
        final index = entry.key;
        final option = entry.value;
        final isSelected = gameProvider.selectedAnswer == option;
        final isCorrect = gameProvider.hasAnswered &&
            index == gameProvider.currentQuestion!.correctAnswer;
        final isWrong = gameProvider.hasAnswered &&
            isSelected &&
            index != gameProvider.currentQuestion!.correctAnswer;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: AnswerOption(
            text: option,
            isSelected: isSelected,
            isCorrect: isCorrect,
            isWrong: isWrong,
            isEnabled: !gameProvider.hasAnswered,
            onTap: () => gameProvider.selectAnswer(option),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButton(GameProvider gameProvider) {
    if (!gameProvider.hasAnswered) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: gameProvider.selectedAnswer != null
              ? () => _submitAnswer(gameProvider)
              : null,
          child: const Text('Submit Answer'),
        ),
      );
    }

    return Column(
      children: [
        if (gameProvider.currentQuestion!.explanation.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              gameProvider.currentQuestion!.explanation,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _nextQuestion(gameProvider),
            child: Text(
              gameProvider.hasNextQuestion ? 'Next Question' : 'Finish Game',
            ),
          ),
        ),
      ],
    );
  }

  void _submitAnswer(GameProvider gameProvider) {
    final isCorrect = gameProvider.submitAnswer();
    
    // Play success/failure animation
    if (isCorrect) {
      _scaleController.reset();
      _scaleController.forward();
    }
  }

  void _nextQuestion(GameProvider gameProvider) {
    _slideController.reset();
    gameProvider.nextQuestion();
    _slideController.forward();
  }

  void _navigateToResults() {
    final gameProvider = context.read<GameProvider>();
    final progressProvider = context.read<ProgressProvider>();
    
    if (gameProvider.currentSession != null) {
      progressProvider.updateProgressFromSession(gameProvider.currentSession!);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          session: gameProvider.currentSession!,
        ),
      ),
    );
  }

  String _getGameModeTitle() {
    switch (widget.gameMode) {
      case 'self':
        return 'My Perspective';
      case 'other':
        return 'Others\' Views';
      case 'observer':
        return 'Observer Mode';
      case 'mixed':
        return 'Mixed Challenge';
      default:
        return 'Perspective Quest';
    }
  }

  Future<bool> _showExitDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit Game?'),
          content: const Text('Your progress will be lost if you exit now.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Continue Playing'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}
