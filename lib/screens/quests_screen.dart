import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../blocs/app_bloc.dart';
import '../services/quest_service.dart';

class QuestsScreen extends StatefulWidget {
  const QuestsScreen({super.key});

  @override
  _QuestsScreenState createState() => _QuestsScreenState();
}

class _QuestsScreenState extends State<QuestsScreen> {
  final QuestService _questService = QuestService();
  List<Map<String, dynamic>> _dailyQuests = [];
  List<Map<String, dynamic>> _availableQuests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuests();
  }

  Future<void> _loadQuests() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final dailyQuests = await _questService.getDailyQuests();
      final availableQuests = await _questService.getAvailableQuests('Balanced', 0.5);
      
      setState(() {
        _dailyQuests = dailyQuests;
        _availableQuests = availableQuests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load quests: $e')),
      );
    }
  }

  Future<void> _completeQuest(Map<String, dynamic> quest) async {
    try {
      await _questService.completeQuest(quest['id'], quest['points']);
      context.read<AppBloc>().add(CompleteQuest(quest['id'], quest['points']));
      
      // Show celebration animation
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Quest Completed!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Lottie.asset('assets/animations/reward.json'),
              const Icon(Icons.celebration, size: 64, color: Colors.amber),
              const SizedBox(height: 16),
              Text('You earned ${quest['points']} points!'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Awesome!'),
            ),
          ],
        ),
      );

      // Refresh quests
      _loadQuests();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to complete quest: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quests'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadQuests,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Daily Quests Section
                  Text(
                    'Daily Quests',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  if (_dailyQuests.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No daily quests available'),
                      ),
                    )
                  else
                    ..._dailyQuests.map((quest) => _buildQuestCard(quest)),
                  
                  const SizedBox(height: 24),
                  
                  // Available Quests Section
                  Text(
                    'Available Quests',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  if (_availableQuests.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Complete daily quests to unlock more!'),
                      ),
                    )
                  else
                    ..._availableQuests.map((quest) => _buildQuestCard(quest)),
                ],
              ),
            ),
    );
  }

  Widget _buildQuestCard(Map<String, dynamic> quest) {
    Color difficultyColor;
    IconData difficultyIcon;
    
    switch (quest['difficulty']) {
      case 'easy':
        difficultyColor = Colors.green;
        difficultyIcon = Icons.sentiment_very_satisfied;
        break;
      case 'medium':
        difficultyColor = Colors.orange;
        difficultyIcon = Icons.sentiment_neutral;
        break;
      case 'hard':
        difficultyColor = Colors.red;
        difficultyIcon = Icons.sentiment_very_dissatisfied;
        break;
      default:
        difficultyColor = Colors.grey;
        difficultyIcon = Icons.help;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getQuestTypeIcon(quest['type']),
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    quest['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(difficultyIcon, size: 16, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        quest['difficulty'].toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  backgroundColor: difficultyColor,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(quest['description']),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.stars, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '${quest['points']} points',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => _completeQuest(quest),
                  child: const Text('Complete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getQuestTypeIcon(String type) {
    switch (type) {
      case 'reading':
        return Icons.article;
      case 'social':
        return Icons.people;
      case 'sharing':
        return Icons.share;
      case 'verification':
        return Icons.fact_check;
      case 'diversify':
        return Icons.diversity_3;
      case 'education':
        return Icons.school;
      case 'teaching':
        return Icons.psychology;
      default:
        return Icons.assignment;
    }
  }
}
