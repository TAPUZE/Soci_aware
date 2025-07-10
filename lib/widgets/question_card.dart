import 'package:flutter/material.dart';
import '../models/perspective_question.dart';
import '../utils/app_theme.dart';

class QuestionCard extends StatelessWidget {
  final PerspectiveQuestion question;

  const QuestionCard({
    Key? key,
    required this.question,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildScenario(context),
            const SizedBox(height: 20),
            _buildQuestion(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getTypeColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getTypeIcon(),
                size: 16,
                color: _getTypeColor(),
              ),
              const SizedBox(width: 6),
              Text(
                _getTypeLabel(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _getTypeColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        _buildDifficultyIndicator(context),
      ],
    );
  }

  Widget _buildDifficultyIndicator(BuildContext context) {
    return Row(
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.only(left: 2),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < question.difficulty
                ? AppTheme.warningColor
                : AppTheme.textSecondary.withOpacity(0.3),
          ),
        );
      }),
    );
  }

  Widget _buildScenario(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.movie,
                size: 18,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 6),
              Text(
                'Scenario',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            question.scenario,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.help_outline,
              size: 18,
              color: AppTheme.accentColor,
            ),
            const SizedBox(width: 6),
            Text(
              'Question',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.accentColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          question.question,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            height: 1.3,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getTypeColor() {
    switch (question.type) {
      case PerspectiveType.self:
        return AppTheme.primaryColor;
      case PerspectiveType.other:
        return AppTheme.secondaryColor;
      case PerspectiveType.observer:
        return AppTheme.warningColor;
    }
  }

  IconData _getTypeIcon() {
    switch (question.type) {
      case PerspectiveType.self:
        return Icons.person;
      case PerspectiveType.other:
        return Icons.people;
      case PerspectiveType.observer:
        return Icons.remove_red_eye;
    }
  }

  String _getTypeLabel() {
    switch (question.type) {
      case PerspectiveType.self:
        return 'My Perspective';
      case PerspectiveType.other:
        return 'Others\' Views';
      case PerspectiveType.observer:
        return 'Observer Mode';
    }
  }
}
