import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../models/game_session.dart';
import '../utils/app_theme.dart';
import '../widgets/score_card.dart';
import '../widgets/achievement_badge.dart';
import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  final GameSession session;

  const ResultScreen({
    Key? key,
    required this.session,
  }) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
      
      // Show confetti for good performance
      if (widget.session.accuracy >= 0.7) {
        _confettiController.play();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.primaryColor.withOpacity(0.1),
                  AppTheme.backgroundColor,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 32),
                          _buildHeader(),
                          const SizedBox(height: 32),
                          _buildScoreCard(),
                          const SizedBox(height: 24),
                          _buildAchievements(),
                          const SizedBox(height: 24),
                          _buildEncouragement(),
                        ],
                      ),
                    ),
                  ),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 1.5708, // radians - 90 degrees
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              maxBlastForce: 100,
              minBlastForce: 80,
              gravity: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getHeaderColor(),
            ),
            child: Icon(
              _getHeaderIcon(),
              size: 64,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _getHeaderTitle(),
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _getHeaderSubtitle(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScoreCard(session: widget.session),
    );
  }

  Widget _buildAchievements() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Achievements',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _getAchievements(),
          ),
        ],
      ),
    );
  }

  Widget _buildEncouragement() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              Icons.lightbulb,
              size: 32,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 12),
            Text(
              _getEncouragementMessage(),
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _playAgain(),
              icon: const Icon(Icons.refresh),
              label: const Text('Play Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _goHome(),
              icon: const Icon(Icons.home),
              label: const Text('Back to Home'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: BorderSide(color: AppTheme.primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getHeaderColor() {
    final accuracy = widget.session.accuracy;
    if (accuracy >= 0.8) return AppTheme.successColor;
    if (accuracy >= 0.6) return AppTheme.warningColor;
    return AppTheme.accentColor;
  }

  IconData _getHeaderIcon() {
    final accuracy = widget.session.accuracy;
    if (accuracy >= 0.8) return Icons.emoji_events;
    if (accuracy >= 0.6) return Icons.thumb_up;
    return Icons.psychology;
  }

  String _getHeaderTitle() {
    final accuracy = widget.session.accuracy;
    if (accuracy >= 0.8) return 'Excellent!';
    if (accuracy >= 0.6) return 'Good Job!';
    return 'Keep Learning!';
  }

  String _getHeaderSubtitle() {
    final accuracy = widget.session.accuracy;
    if (accuracy >= 0.8) return 'You\'re a perspective expert!';
    if (accuracy >= 0.6) return 'You\'re getting better at understanding others!';
    return 'Every question helps you grow!';
  }

  List<Widget> _getAchievements() {
    final achievements = <Widget>[];
    final accuracy = widget.session.accuracy;

    if (widget.session.isCompleted) {
      achievements.add(const AchievementBadge(
        icon: Icons.check_circle,
        label: 'Completed',
        color: AppTheme.successColor,
      ));
    }

    if (accuracy == 1.0) {
      achievements.add(const AchievementBadge(
        icon: Icons.star,
        label: 'Perfect Score',
        color: AppTheme.warningColor,
      ));
    }

    if (accuracy >= 0.8) {
      achievements.add(const AchievementBadge(
        icon: Icons.school,
        label: 'Quick Learner',
        color: AppTheme.primaryColor,
      ));
    }

    if (widget.session.score >= 5) {
      achievements.add(const AchievementBadge(
        icon: Icons.psychology,
        label: 'Empathy Expert',
        color: AppTheme.secondaryColor,
      ));
    }

    return achievements;
  }

  String _getEncouragementMessage() {
    final accuracy = widget.session.accuracy;
    
    if (accuracy >= 0.9) {
      return 'Amazing! You have excellent perspective-taking skills. You really understand how to see things from different points of view!';
    } else if (accuracy >= 0.7) {
      return 'Great work! You\'re developing strong empathy skills. Keep practicing to become even better at understanding others!';
    } else if (accuracy >= 0.5) {
      return 'Good effort! Understanding different perspectives takes practice. Each question you answer helps you grow!';
    } else {
      return 'Keep going! Learning to see from different perspectives is a valuable skill. Every attempt makes you better!';
    }
  }

  void _playAgain() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  void _goHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }
}
