import '../models/perspective_question.dart';

class QuestionService {
  static final List<PerspectiveQuestion> _allQuestions = [
    // Self-Perspective Questions
    PerspectiveQuestion(
      id: 'sp_001',
      scenario: 'You worked really hard on a drawing, but your friend says it doesn\'t look good.',
      question: 'How would you feel in this situation?',
      options: ['Happy and excited', 'Hurt and disappointed', 'Angry and frustrated', 'Confused and worried'],
      correctAnswer: 1,
      type: PerspectiveType.self,
      explanation: 'When someone criticizes something we\'ve worked hard on, it\'s natural to feel hurt and disappointed.',
      difficulty: 1,
    ),
    PerspectiveQuestion(
      id: 'sp_002',
      scenario: 'You forgot to study for a test and got a bad grade. Your parents find out.',
      question: 'What would you be thinking about?',
      options: ['How unfair the test was', 'How disappointed your parents might be', 'How you should have studied more', 'How the teacher made the test too hard'],
      correctAnswer: 2,
      type: PerspectiveType.self,
      explanation: 'Reflecting on our own actions and what we could have done differently shows self-awareness.',
      difficulty: 2,
    ),
    
    // Other-Perspective Questions
    PerspectiveQuestion(
      id: 'op_001',
      scenario: 'Your classmate Maya always sits alone at lunch and looks sad.',
      question: 'How do you think Maya might be feeling?',
      options: ['Happy to have space', 'Lonely and left out', 'Angry at everyone', 'Excited about eating'],
      correctAnswer: 1,
      type: PerspectiveType.other,
      explanation: 'When someone sits alone and looks sad, they are likely feeling lonely and left out.',
      difficulty: 1,
    ),
    PerspectiveQuestion(
      id: 'op_002',
      scenario: 'Your little brother broke his favorite toy and is crying.',
      question: 'What is your brother probably thinking?',
      options: ['This is fun!', 'I can easily get a new one', 'I\'m so upset this is broken', 'I don\'t care about toys'],
      correctAnswer: 2,
      type: PerspectiveType.other,
      explanation: 'When a child\'s favorite toy breaks, they feel upset because it was important to them.',
      difficulty: 1,
    ),
    PerspectiveQuestion(
      id: 'op_003',
      scenario: 'Your friend Sarah studied really hard for a math test but still got a low score.',
      question: 'How might Sarah be feeling about her effort?',
      options: ['Proud of trying hard', 'Frustrated that hard work didn\'t pay off', 'Happy with any score', 'Indifferent about the result'],
      correctAnswer: 1,
      type: PerspectiveType.other,
      explanation: 'When hard work doesn\'t lead to the expected result, people often feel frustrated and disappointed.',
      difficulty: 2,
    ),

    // Observer Perspective Questions
    PerspectiveQuestion(
      id: 'obs_001',
      scenario: 'Alex accidentally knocked over Jamie\'s art project. Jamie started crying, and Alex looked shocked.',
      question: 'What might someone watching this situation think?',
      options: ['Alex did it on purpose', 'It was an accident and both kids feel bad', 'Jamie is overreacting', 'Alex should be punished'],
      correctAnswer: 1,
      type: PerspectiveType.observer,
      explanation: 'An observer can see that both children are upset - Alex by the accident and Jamie by the damaged project.',
      difficulty: 2,
    ),
    PerspectiveQuestion(
      id: 'obs_002',
      scenario: 'During group work, Tom keeps interrupting others and taking over the project. The other kids look frustrated.',
      question: 'What might a teacher observing this think?',
      options: ['Tom is a natural leader', 'Tom needs to learn to collaborate better', 'The other kids are lazy', 'Everything is going well'],
      correctAnswer: 1,
      type: PerspectiveType.observer,
      explanation: 'A teacher would notice that Tom\'s behavior is causing frustration and needs guidance on collaboration.',
      difficulty: 2,
    ),
    PerspectiveQuestion(
      id: 'obs_003',
      scenario: 'Lisa shares her snack with Ben who forgot his lunch. Ben smiles and says thank you.',
      question: 'What might other students think about Lisa?',
      options: ['She\'s showing off', 'She\'s kind and caring', 'She made a mistake', 'She\'s trying to get attention'],
      correctAnswer: 1,
      type: PerspectiveType.observer,
      explanation: 'Others would likely see Lisa\'s action as kind and caring since she helped someone in need.',
      difficulty: 1,
    ),

    // More complex scenarios
    PerspectiveQuestion(
      id: 'sp_003',
      scenario: 'You really want to play a video game, but your mom asks you to help with dinner first.',
      question: 'What thoughts might go through your mind?',
      options: ['This is unfair, I should play first', 'I can help now and play later', 'Mom doesn\'t understand me', 'I\'ll pretend I didn\'t hear her'],
      correctAnswer: 1,
      type: PerspectiveType.self,
      explanation: 'The most mature response is to recognize that helping first and playing later is a reasonable compromise.',
      difficulty: 2,
    ),
    
    PerspectiveQuestion(
      id: 'op_004',
      scenario: 'Your grandmother gives you a sweater she knitted, but it\'s not your style.',
      question: 'How might your grandmother feel about giving you this gift?',
      options: ['Worried you won\'t like it', 'Proud and loving for making it', 'Indifferent about your reaction', 'Expecting you to wear it always'],
      correctAnswer: 1,
      type: PerspectiveType.other,
      explanation: 'Grandparents usually feel proud and loving when giving handmade gifts, wanting to show their care.',
      difficulty: 2,
    ),

    PerspectiveQuestion(
      id: 'obs_004',
      scenario: 'During recess, a group of kids won\'t let Emma join their game. Emma walks away looking sad.',
      question: 'What might a playground supervisor think about this situation?',
      options: ['Emma should find other friends', 'The group needs to be more inclusive', 'This is normal playground behavior', 'Emma is being too sensitive'],
      correctAnswer: 1,
      type: PerspectiveType.observer,
      explanation: 'A supervisor would recognize this as exclusion and see the need to encourage more inclusive behavior.',
      difficulty: 3,
    ),

    // Advanced empathy scenarios
    PerspectiveQuestion(
      id: 'sp_004',
      scenario: 'Your best friend got the role you wanted in the school play.',
      question: 'How might you feel about your friend\'s success?',
      options: ['Only happy for them', 'Disappointed but trying to be supportive', 'Angry and jealous', 'Like it doesn\'t matter'],
      correctAnswer: 1,
      type: PerspectiveType.self,
      explanation: 'It\'s normal to feel disappointed about not getting what we wanted while also caring about our friend\'s happiness.',
      difficulty: 3,
    ),

    PerspectiveQuestion(
      id: 'op_005',
      scenario: 'Your classmate Kevin often gets in trouble and other kids avoid him.',
      question: 'How might Kevin feel about being avoided?',
      options: ['Happy to be left alone', 'Hurt and wanting to belong', 'Proud of his reputation', 'Indifferent to others'],
      correctAnswer: 1,
      type: PerspectiveType.other,
      explanation: 'Most people, especially children, want to feel accepted and included. Being avoided likely makes Kevin feel hurt.',
      difficulty: 3,
    ),
  ];

  Future<List<PerspectiveQuestion>> getQuestions({
    String? gameMode,
    int? difficulty,
    int count = 10,
  }) async {
    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 500));

    List<PerspectiveQuestion> filteredQuestions = List.from(_allQuestions);

    // Filter by game mode (perspective type)
    if (gameMode != null) {
      switch (gameMode) {
        case 'self':
          filteredQuestions = filteredQuestions
              .where((q) => q.type == PerspectiveType.self)
              .toList();
          break;
        case 'other':
          filteredQuestions = filteredQuestions
              .where((q) => q.type == PerspectiveType.other)
              .toList();
          break;
        case 'observer':
          filteredQuestions = filteredQuestions
              .where((q) => q.type == PerspectiveType.observer)
              .toList();
          break;
        case 'mixed':
        default:
          // Keep all questions
          break;
      }
    }

    // Filter by difficulty
    if (difficulty != null) {
      filteredQuestions = filteredQuestions
          .where((q) => q.difficulty == difficulty)
          .toList();
    }

    // Shuffle and take requested count
    filteredQuestions.shuffle();
    return filteredQuestions.take(count).toList();
  }

  Future<PerspectiveQuestion?> getQuestionById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    try {
      return _allQuestions.firstWhere((q) => q.id == id);
    } catch (e) {
      return null;
    }
  }

  List<String> getGameModes() {
    return ['mixed', 'self', 'other', 'observer'];
  }

  List<int> getDifficultyLevels() {
    return [1, 2, 3];
  }
}
