import 'package:flutter/material.dart';
import '../models/player_progress.dart';
import '../utils/app_theme.dart';

class ProgressCard extends StatelessWidget {
  final PlayerProgress progress;

  const ProgressCard({
    Key? key,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Your Progress',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatColumn(
                    context,
                    'Level',
                    progress.currentLevel.toString(),
                    Icons.star,
                    AppTheme.warningColor,
                  ),
                ),
                Expanded(
                  child: _buildStatColumn(
                    context,
                    'Score',
                    progress.totalScore.toString(),
                    Icons.score,
                    AppTheme.successColor,
                  ),
                ),
                Expanded(
                  child: _buildStatColumn(
                    context,
                    'Accuracy',
                    '${(progress.accuracy * 100).toStringAsFixed(0)}%',
                    Icons.target,
                    AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildExperienceBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildExperienceBar(BuildContext context) {
    final currentLevelXP = (progress.currentLevel - 1) * 100;
    final nextLevelXP = progress.currentLevel * 100;
    final progressInLevel = progress.experiencePoints - currentLevelXP;
    final xpNeededForLevel = nextLevelXP - currentLevelXP;
    final progressPercentage = progressInLevel / xpNeededForLevel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress to Level ${progress.currentLevel + 1}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$progressInLevel / $xpNeededForLevel XP',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progressPercentage.clamp(0.0, 1.0),
          backgroundColor: AppTheme.textSecondary.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
        ),
      ],
    );
  }
}
