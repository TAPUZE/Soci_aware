import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/app_bloc.dart';
import '../services/echo_analyzer.dart';
import '../services/social_api_service.dart';
import '../widgets/progress_wheel.dart';
import 'leaderboard_screen.dart';
import 'quests_screen.dart';
import 'auth_screen.dart';

class AnalyzerScreen extends StatefulWidget {
  const AnalyzerScreen({super.key});

  @override
  _AnalyzerScreenState createState() => _AnalyzerScreenState();
}

class _AnalyzerScreenState extends State<AnalyzerScreen> {
  final EchoAnalyzer _analyzer = EchoAnalyzer();
  final SocialApiService _socialApi = SocialApiService();
  
  bool _isAnalyzing = false;
  double _echoScore = 0.0;
  String _biasLean = 'Unknown';
  String _currentQuest = 'Connect your social media to get started!';
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _analyzer.loadModel();
  }

  Future<void> _analyzeWithMockData() async {
    setState(() {
      _isAnalyzing = true;
    });

    try {
      // Use mock data for demonstration
      List<String> posts = await _socialApi.getMockPosts();
      
      _echoScore = _analyzer.calculateEchoScore(posts);
      _biasLean = _analyzer.detectBiasLean(posts);
      _currentQuest = _analyzer.generateQuest(_biasLean, _echoScore);
      _suggestions = _analyzer.generateDiverseContentSuggestions(_biasLean);

      // Update user progress
      context.read<AppBloc>().add(UpdatePoints(10)); // Award points for analysis
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Analysis failed: $e')),
      );
    }

    setState(() {
      _isAnalyzing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Perspective Quest'),
            backgroundColor: Colors.deepPurple,
            actions: [
              IconButton(
                icon: const Icon(Icons.leaderboard),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LeaderboardScreen()),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // User Progress Card
                if (state is AppLoaded) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          ProgressWheel(points: state.progress.points),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Level ${state.progress.level}',
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                                Text('${state.progress.points} points'),
                                Text('${state.progress.badges.length} badges earned'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Analysis Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Echo Chamber Analysis',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        
                        if (_echoScore > 0) ...[
                          LinearProgressIndicator(
                            value: _echoScore,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _echoScore > 0.7 ? Colors.red : 
                              _echoScore > 0.4 ? Colors.orange : Colors.green,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Echo Score: ${(_echoScore * 100).toStringAsFixed(1)}%'),
                          Text('Bias Lean: $_biasLean'),
                          const SizedBox(height: 16),
                        ],

                        ElevatedButton(
                          onPressed: _isAnalyzing ? null : _analyzeWithMockData,
                          child: _isAnalyzing 
                            ? const CircularProgressIndicator()
                            : const Text('Analyze My Feed'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Current Quest
                Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Quest',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(_currentQuest),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const QuestsScreen()),
                          ),
                          child: const Text('View All Quests'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Content Suggestions
                if (_suggestions.isNotEmpty) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recommended Sources',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          ..._suggestions.map((suggestion) => ListTile(
                            leading: const Icon(Icons.article),
                            title: Text(suggestion),
                            dense: true,
                          )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AuthScreen()),
                        ),
                        icon: const Icon(Icons.link),
                        label: const Text('Connect Social Media'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LeaderboardScreen()),
                        ),
                        icon: const Icon(Icons.leaderboard),
                        label: const Text('Leaderboard'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
