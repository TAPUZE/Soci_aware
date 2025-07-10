import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/stats_card.dart';
import '../widgets/achievement_grid.dart';
import '../widgets/level_progress_card.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Progress'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<ProgressProvider>().loadProgress(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.analytics), text: 'Stats'),
            Tab(icon: Icon(Icons.emoji_events), text: 'Achievements'),
            Tab(icon: Icon(Icons.trending_up), text: 'Level'),
          ],
        ),
      ),
      body: Consumer<ProgressProvider>(
        builder: (context, progressProvider, child) {
          if (progressProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return FadeTransition(
            opacity: _fadeAnimation,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildStatsTab(progressProvider),
                _buildAchievementsTab(progressProvider),
                _buildLevelTab(progressProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsTab(ProgressProvider progressProvider) {
    final progress = progressProvider.progress;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overall Statistics',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          StatsCard(
            title: 'Total Score',
            value: progress.totalScore.toString(),
            icon: Icons.star,
            color: AppTheme.warningColor,
          ),
          const SizedBox(height: 12),
          StatsCard(
            title: 'Questions Answered',
            value: progress.questionsAnswered.toString(),
            icon: Icons.quiz,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(height: 12),
          StatsCard(
            title: 'Accuracy',
            value: '${(progress.accuracy * 100).toStringAsFixed(1)}%',
            icon: Icons.target,
            color: AppTheme.successColor,
          ),
          const SizedBox(height: 12),
          StatsCard(
            title: 'Current Level',
            value: progress.currentLevel.toString(),
            icon: Icons.trending_up,
            color: AppTheme.secondaryColor,
          ),
          const SizedBox(height: 24),
          Text(
            'Category Breakdown',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          ...progress.categoryScores.entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: StatsCard(
              title: _getCategoryDisplayName(entry.key),
              value: entry.value.toString(),
              icon: _getCategoryIcon(entry.key),
              color: _getCategoryColor(entry.key),
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildAchievementsTab(ProgressProvider progressProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Achievements Unlocked',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '${progressProvider.progress.unlockedAchievements.length} achievements earned',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          AchievementGrid(
            unlockedAchievements: progressProvider.progress.unlockedAchievements,
          ),
        ],
      ),
    );
  }

  Widget _buildLevelTab(ProgressProvider progressProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          LevelProgressCard(progress: progressProvider.progress),
          const SizedBox(height: 24),
          _buildLevelBenefits(),
        ],
      ),
    );
  }

  Widget _buildLevelBenefits() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: AppTheme.warningColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Level Benefits',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildBenefitItem(
              'Level 2',
              'Unlock medium difficulty questions',
              Icons.psychology,
            ),
            _buildBenefitItem(
              'Level 3',
              'Access to observer mode challenges',
              Icons.remove_red_eye,
            ),
            _buildBenefitItem(
              'Level 5',
              'Unlock hard difficulty questions',
              Icons.school,
            ),
            _buildBenefitItem(
              'Level 7',
              'Special empathy master badge',
              Icons.emoji_events,
            ),
            _buildBenefitItem(
              'Level 10',
              'Perspective taking expert status',
              Icons.star,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String level, String benefit, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  level,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  benefit,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'self':
        return 'My Perspective';
      case 'other':
        return 'Others\' Views';
      case 'observer':
        return 'Observer Mode';
      case 'mixed':
        return 'Mixed Challenge';
      default:
        return category;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'self':
        return Icons.person;
      case 'other':
        return Icons.people;
      case 'observer':
        return Icons.remove_red_eye;
      case 'mixed':
        return Icons.shuffle;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'self':
        return AppTheme.primaryColor;
      case 'other':
        return AppTheme.secondaryColor;
      case 'observer':
        return AppTheme.warningColor;
      case 'mixed':
        return AppTheme.accentColor;
      default:
        return AppTheme.textSecondary;
    }
  }
}
