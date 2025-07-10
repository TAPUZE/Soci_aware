import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class AnswerOption extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final bool isEnabled;
  final VoidCallback onTap;

  const AnswerOption({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    required this.isEnabled,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Card(
        elevation: isSelected ? 4 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: _getBorderColor(),
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _getBackgroundColor(),
            ),
            child: Row(
              children: [
                _buildIcon(),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: _getTextColor(),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (isCorrect) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.successColor,
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 16,
        ),
      );
    }

    if (isWrong) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.accentColor,
        ),
        child: const Icon(
          Icons.close,
          color: Colors.white,
          size: 16,
        ),
      );
    }

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
          width: 2,
        ),
        color: isSelected ? AppTheme.primaryColor : Colors.transparent,
      ),
      child: isSelected
          ? const Icon(
              Icons.circle,
              color: Colors.white,
              size: 12,
            )
          : null,
    );
  }

  Color _getBorderColor() {
    if (isCorrect) return AppTheme.successColor;
    if (isWrong) return AppTheme.accentColor;
    if (isSelected) return AppTheme.primaryColor;
    return Colors.transparent;
  }

  Color _getBackgroundColor() {
    if (isCorrect) return AppTheme.successColor.withOpacity(0.1);
    if (isWrong) return AppTheme.accentColor.withOpacity(0.1);
    if (isSelected) return AppTheme.primaryColor.withOpacity(0.1);
    return Colors.white;
  }

  Color _getTextColor() {
    if (isCorrect) return AppTheme.successColor;
    if (isWrong) return AppTheme.accentColor;
    if (isSelected) return AppTheme.primaryColor;
    return AppTheme.textPrimary;
  }
}
