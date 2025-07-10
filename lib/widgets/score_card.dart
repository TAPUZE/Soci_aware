import 'package:flutter/material.dart';
import '../models/game_session.dart';
import '../utils/app_theme.dart';

class ScoreCard extends StatelessWidget {
  final GameSession session;

  const ScoreCard({
    Key? key,
    required this.session,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accuracy = session.accuracy;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _getScoreColor().withOpacity(0.1),
              _getScoreColor().withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildScoreItem(
                    context,
                    'Score',
                    '${session.score}/${session.totalQuestions}',
                    Icons.star,
                    AppTheme.warningColor,
                  ),
                ),
                Expanded(
                  child: _buildScoreItem(
                    context,
                    'Accuracy',
                    '${(accuracy * 100).toStringAsFixed(1)}%',
                    Icons.target,
                    _getScoreColor(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildProgressBar(context, accuracy),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 32,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context, double accuracy) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: AppTheme.textSecondary.withOpacity(0.2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: accuracy,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _getScoreColor(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _getPerformanceText(accuracy),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Color _getScoreColor() {
    final accuracy = session.accuracy;
    if (accuracy >= 0.8) return AppTheme.successColor;
    if (accuracy >= 0.6) return AppTheme.warningColor;
    return AppTheme.accentColor;
  }

  String _getPerformanceText(double accuracy) {
    if (accuracy >= 0.9) return 'Outstanding performance!';
    if (accuracy >= 0.8) return 'Excellent work!';
    if (accuracy >= 0.7) return 'Great job!';
    if (accuracy >= 0.6) return 'Good effort!';
    if (accuracy >= 0.5) return 'Keep practicing!';
    return 'Learning in progress!';
  }
}
