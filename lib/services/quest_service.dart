import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> getDailyQuests() async {
    try {
      // In a real app, this would be more sophisticated
      // For now, return a mix of daily quests
      return [
        {
          'id': 'read_opposing_view',
          'title': 'Read Opposing View',
          'description': 'Read an article from a perspective different from your usual sources',
          'points': 50,
          'type': 'reading',
          'difficulty': 'medium',
        },
        {
          'id': 'engage_respectfully',
          'title': 'Respectful Engagement',
          'description': 'Comment thoughtfully on a post you disagree with',
          'points': 75,
          'type': 'social',
          'difficulty': 'hard',
        },
        {
          'id': 'share_diverse_content',
          'title': 'Share Diverse Content',
          'description': 'Share an article that presents multiple viewpoints',
          'points': 40,
          'type': 'sharing',
          'difficulty': 'easy',
        },
        {
          'id': 'fact_check',
          'title': 'Fact Checker',
          'description': 'Verify the accuracy of a news story using multiple sources',
          'points': 60,
          'type': 'verification',
          'difficulty': 'medium',
        },
      ];
    } catch (e) {
      print('Failed to fetch quests: $e');
      return [];
    }
  }

  Future<void> completeQuest(String questId, int reward) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Update user's completed quests and points
        await _firestore.collection('users').doc(user.uid).update({
          'completedQuests': FieldValue.arrayUnion([questId]),
          'points': FieldValue.increment(reward),
          'lastQuestCompleted': FieldValue.serverTimestamp(),
        });

        // Log quest completion for analytics
        await _firestore.collection('quest_completions').add({
          'userId': user.uid,
          'questId': questId,
          'points': reward,
          'completedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Failed to complete quest: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAvailableQuests(String biasLean, double echoScore) async {
    List<Map<String, dynamic>> quests = [];

    if (echoScore > 0.7) {
      // High echo chamber - suggest breaking out
      quests.addAll([
        {
          'id': 'break_echo_chamber',
          'title': 'Break the Echo Chamber',
          'description': 'Follow 3 news sources with different political perspectives',
          'points': 100,
          'type': 'diversify',
          'difficulty': 'hard',
        },
        {
          'id': 'opposite_perspective',
          'title': 'Opposite Perspective',
          'description': 'Read and summarize an article that challenges your views',
          'points': 80,
          'type': 'reading',
          'difficulty': 'hard',
        },
      ]);
    } else if (echoScore > 0.4) {
      // Moderate echo chamber
      quests.addAll([
        {
          'id': 'find_common_ground',
          'title': 'Find Common Ground',
          'description': 'Identify shared values with someone of different political views',
          'points': 60,
          'type': 'social',
          'difficulty': 'medium',
        },
        {
          'id': 'balanced_reading',
          'title': 'Balanced Reading',
          'description': 'Read articles from both sides of a current issue',
          'points': 50,
          'type': 'reading',
          'difficulty': 'medium',
        },
      ]);
    } else {
      // Low echo chamber - maintain diversity
      quests.addAll([
        {
          'id': 'media_literacy',
          'title': 'Media Literacy Champion',
          'description': 'Share an article about identifying bias in news',
          'points': 40,
          'type': 'education',
          'difficulty': 'easy',
        },
        {
          'id': 'mentor_others',
          'title': 'Perspective Mentor',
          'description': 'Help someone else understand a different viewpoint',
          'points': 70,
          'type': 'teaching',
          'difficulty': 'medium',
        },
      ]);
    }

    return quests;
  }

  Future<Map<String, dynamic>> getQuestStats() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        QuerySnapshot completions = await _firestore
            .collection('quest_completions')
            .where('userId', isEqualTo: user.uid)
            .get();

        int totalCompleted = completions.docs.length;
        int totalPoints = completions.docs.fold(0, (sum, doc) {
          return sum + (doc.data() as Map<String, dynamic>)['points'] as int;
        });

        return {
          'totalCompleted': totalCompleted,
          'totalPoints': totalPoints,
          'averagePointsPerQuest': totalCompleted > 0 ? totalPoints / totalCompleted : 0,
        };
      }
    } catch (e) {
      print('Failed to get quest stats: $e');
    }
    
    return {
      'totalCompleted': 0,
      'totalPoints': 0,
      'averagePointsPerQuest': 0,
    };
  }
}
