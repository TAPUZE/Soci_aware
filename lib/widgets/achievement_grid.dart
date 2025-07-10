import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import 'achievement_badge.dart';

class AchievementGrid extends StatelessWidget {
  final List<String> unlockedAchievements;

  const AchievementGrid({
    Key? key,
    required this.unlockedAchievements,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allAchievements = _getAllAchievements();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: allAchievements.length,
      itemBuilder: (context, index) {
        final achievement = allAchievements[index];
        final isUnlocked = unlockedAchievements.contains(achievement['id']);

        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isUnlocked ? Colors.white : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isUnlocked
                  ? achievement['color']
                  : Colors.grey.withOpacity(0.3),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                achievement['icon'],
                size: 32,
                color: isUnlocked
                    ? achievement['color']
                    : Colors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 8),
              Text(
                achievement['title'],
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isUnlocked
                      ? AppTheme.textPrimary
                      : Colors.grey.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                achievement['description'],
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isUnlocked
                      ? AppTheme.textSecondary
                      : Colors.grey.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _getAllAchievements() {
    return [
      {
        'id': 'first_game',
        'title': 'First Steps',
        'description': 'Played first game',
        'icon': Icons.play_arrow,
        'color': AppTheme.primaryColor,
      },
      {
        'id': 'perfect_score',
        'title': 'Perfect!',
        'description': 'Got 100% accuracy',
        'icon': Icons.star,
        'color': AppTheme.warningColor,
      },
      {
        'id': 'ten_games',
        'title': 'Dedicated',
        'description': 'Answered 100 questions',
        'icon': Icons.quiz,
        'color': AppTheme.successColor,
      },
      {
        'id': 'high_accuracy',
        'title': 'Precise',
        'description': '80%+ accuracy',
        'icon': Icons.target,
        'color': AppTheme.accentColor,
      },
      {
        'id': 'level_five',
        'title': 'Rising Star',
        'description': 'Reached level 5',
        'icon': Icons.trending_up,
        'color': AppTheme.secondaryColor,
      },
      {
        'id': 'empathy_expert',
        'title': 'Empathy Expert',
        'description': 'Master of perspective',
        'icon': Icons.psychology,
        'color': AppTheme.primaryColor,
      },
    ];
  }
}
