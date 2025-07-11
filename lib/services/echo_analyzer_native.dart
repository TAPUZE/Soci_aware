import 'dart:math';
import 'package:collection/collection.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class EchoAnalyzer {
  Interpreter? _interpreter;
  
  final List<String> conservativeKeywords = [
    'conservative', 'right-wing', 'right', 'taxes low', 'immigration control',
    'traditional values', 'free market', 'small government', 'law and order'
  ];
  
  final List<String> liberalKeywords = [
    'liberal', 'left-wing', 'progressive', 'equality', 'climate action',
    'social justice', 'government programs', 'diversity', 'healthcare reform'
  ];

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/sentiment_model.tflite');
    } catch (e) {
      print('Model loading failed: $e');
      // Continue without model for now
    }
  }

  double calculateEchoScore(List<String> posts) {
    if (posts.isEmpty) return 0.0;

    Map<String, int> keywordCounts = {};
    int totalKeywords = 0;

    // Count keywords in posts
    for (String post in posts) {
      String lowerPost = post.toLowerCase();
      
      for (String keyword in conservativeKeywords) {
        if (lowerPost.contains(keyword)) {
          keywordCounts['conservative'] = (keywordCounts['conservative'] ?? 0) + 1;
          totalKeywords++;
        }
      }
      
      for (String keyword in liberalKeywords) {
        if (lowerPost.contains(keyword)) {
          keywordCounts['liberal'] = (keywordCounts['liberal'] ?? 0) + 1;
          totalKeywords++;
        }
      }
    }

    if (totalKeywords == 0) return 0.0;

    // Calculate dominance of one perspective
    int conservativeCount = keywordCounts['conservative'] ?? 0;
    int liberalCount = keywordCounts['liberal'] ?? 0;
    
    double ratio = totalKeywords > 0 ? max(conservativeCount, liberalCount) / totalKeywords : 0.0;
    
    // Echo score: higher when one perspective dominates
    return ratio;
  }

  String detectBiasLean(List<String> posts) {
    Map<String, int> keywordCounts = {};
    
    for (String post in posts) {
      String lowerPost = post.toLowerCase();
      
      for (String keyword in conservativeKeywords) {
        if (lowerPost.contains(keyword)) {
          keywordCounts['conservative'] = (keywordCounts['conservative'] ?? 0) + 1;
        }
      }
      
      for (String keyword in liberalKeywords) {
        if (lowerPost.contains(keyword)) {
          keywordCounts['liberal'] = (keywordCounts['liberal'] ?? 0) + 1;
        }
      }
    }

    int conservativeCount = keywordCounts['conservative'] ?? 0;
    int liberalCount = keywordCounts['liberal'] ?? 0;
    
    if (conservativeCount > liberalCount) {
      return 'Conservative-leaning';
    } else if (liberalCount > conservativeCount) {
      return 'Liberal-leaning';
    } else {
      return 'Balanced';
    }
  }

  String generateQuest(String biasLean, double echoScore) {
    List<String> quests = [];
    
    if (echoScore > 0.7) {
      quests.addAll([
        'Read an article from the opposite political perspective',
        'Follow a news source with different viewpoints',
        'Engage respectfully with someone who disagrees with you',
        'Share content that presents multiple perspectives',
      ]);
    } else if (echoScore > 0.4) {
      quests.addAll([
        'Find common ground with someone of different views',
        'Read fact-checking articles on recent topics',
        'Subscribe to a balanced news aggregator',
      ]);
    } else {
      quests.addAll([
        'Continue reading diverse sources',
        'Share educational content about media literacy',
        'Help others understand different perspectives',
      ]);
    }
    
    return quests[Random().nextInt(quests.length)];
  }

  List<String> generateDiverseContentSuggestions(String biasLean) {
    if (biasLean.contains('Conservative')) {
      return [
        'NPR News',
        'BBC World Service',
        'The Guardian Opinion',
        'Vox Explainers',
        'ProPublica Investigations'
      ];
    } else if (biasLean.contains('Liberal')) {
      return [
        'Wall Street Journal',
        'The Economist',
        'National Review',
        'Reason Magazine',
        'Financial Times'
      ];
    } else {
      return [
        'Reuters',
        'AP News',
        'AllSides',
        'Ground News',
        'Factual Media'
      ];
    }
  }
}
