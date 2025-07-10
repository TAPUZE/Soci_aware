import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/game_mode_card.dart';
import '../widgets/progress_card.dart';
import 'game_screen.dart';
import 'progress_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Load player progress
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProgressProvider>().loadProgress();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildProgressCard(),
                const SizedBox(height: 32),
                _buildGameModes(),
                const SizedBox(height: 24),
                _buildQuickActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Perspective Quest',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Explore different points of view!',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.visibility,
            size: 32,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard() {
    return Consumer<ProgressProvider>(
      builder: (context, progressProvider, child) {
        if (progressProvider.isLoading) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return ProgressCard(progress: progressProvider.progress);
      },
    );
  }

  Widget _buildGameModes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Adventure',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            GameModeCard(
              title: 'My Perspective',
              description: 'How would you feel?',
              icon: Icons.person,
              color: AppTheme.primaryColor,
              onTap: () => _startGame('self'),
            ),
            GameModeCard(
              title: 'Others\' Views',
              description: 'How do others feel?',
              icon: Icons.people,
              color: AppTheme.secondaryColor,
              onTap: () => _startGame('other'),
            ),
            GameModeCard(
              title: 'Observer Mode',
              description: 'What would others think?',
              icon: Icons.remove_red_eye,
              color: AppTheme.warningColor,
              onTap: () => _startGame('observer'),
            ),
            GameModeCard(
              title: 'Mixed Challenge',
              description: 'All perspectives!',
              icon: Icons.shuffle,
              color: AppTheme.accentColor,
              onTap: () => _startGame('mixed'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _navigateToProgress(),
                icon: const Icon(Icons.analytics),
                label: const Text('View Progress'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showDifficultyDialog(),
                icon: const Icon(Icons.settings),
                label: const Text('Practice Mode'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.textSecondary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _startGame(String gameMode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(gameMode: gameMode),
      ),
    );
  }

  void _navigateToProgress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProgressScreen(),
      ),
    );
  }

  void _showDifficultyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Difficulty'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.sentiment_satisfied, color: AppTheme.successColor),
                title: const Text('Easy'),
                subtitle: const Text('Simple scenarios'),
                onTap: () {
                  Navigator.pop(context);
                  _startGameWithDifficulty('mixed', 1);
                },
              ),
              ListTile(
                leading: Icon(Icons.sentiment_neutral, color: AppTheme.warningColor),
                title: const Text('Medium'),
                subtitle: const Text('Moderate challenges'),
                onTap: () {
                  Navigator.pop(context);
                  _startGameWithDifficulty('mixed', 2);
                },
              ),
              ListTile(
                leading: Icon(Icons.sentiment_very_dissatisfied, color: AppTheme.accentColor),
                title: const Text('Hard'),
                subtitle: const Text('Complex situations'),
                onTap: () {
                  Navigator.pop(context);
                  _startGameWithDifficulty('mixed', 3);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _startGameWithDifficulty(String gameMode, int difficulty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          gameMode: gameMode,
          difficulty: difficulty,
        ),
      ),
    );
  }
}
