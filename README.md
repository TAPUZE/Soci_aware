# Soci_aware - Social Media Echo Chamber Analysis

A Flutter-based app that analyzes social media feeds for echo chambers and bias, helping users diversify their information diet through gamified quests and challenges.

## Features

- **Echo Chamber Analysis**:
  - AI-powered bias detection in social media feeds
  - Real-time echo chamber scoring
  - Personalized perspective diversity metrics
  - Content source analysis and recommendations

- **Gamification System**:
  - Points and leveling system
  - Achievement badges and rewards
  - Leaderboards and social competition
  - Daily and weekly quest challenges

- **Social Media Integration**:
  - X (Twitter) API v2 integration
  - Instagram Graph API support
  - Privacy-first local analysis
  - Secure token storage

## Installation

1. Make sure you have Flutter installed on your system
2. Clone this repository:
   ```bash
   git clone https://github.com/TAPUZE/Soci_aware.git
   cd Soci_aware
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Dependencies

- **flutter**: SDK for building the app
- **firebase_core**: Firebase initialization
- **firebase_auth**: User authentication
- **cloud_firestore**: NoSQL database
- **flutter_bloc**: State management
- **http**: API communication
- **webview_flutter**: OAuth authentication
- **flutter_secure_storage**: Secure token storage
- **tflite_flutter**: On-device AI analysis
- **lottie**: Animations

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── blocs/                    # BLoC state management
├── models/                   # Data models
├── screens/                  # App screens
│   ├── analyzer_screen.dart  # Main analysis dashboard
│   ├── leaderboard_screen.dart # User rankings
│   ├── quests_screen.dart    # Daily challenges
│   └── auth_screen.dart      # Social media connection
├── services/                 # Business logic
│   ├── echo_analyzer.dart    # AI analysis engine
│   ├── social_api_service.dart # API integrations
│   ├── quest_service.dart    # Quest management
│   └── auth_service.dart     # Authentication
└── widgets/                  # Reusable UI components
```

## Core Features

### Echo Chamber Analysis
Analyzes your social media feeds to detect bias patterns and echo chamber formation using AI and keyword analysis.

### Gamified Quests
Personalized challenges designed to break you out of your echo chamber:
- Read opposing viewpoints
- Engage with diverse content
- Fact-check information
- Share balanced perspectives

### Social Awareness
Helps users become more aware of their information consumption patterns and encourages diverse perspective-taking.

## Benefits

- **Media Literacy**: Improves ability to identify bias and misinformation
- **Perspective Diversity**: Encourages exposure to different viewpoints
- **Critical Thinking**: Develops analytical skills for information evaluation
- **Social Awareness**: Builds understanding of echo chamber effects
- **Balanced Consumption**: Promotes healthy information diet habits

## Technical Stack

- **Frontend**: Flutter 3.32.4
- **Backend**: Firebase (Auth, Firestore, Functions)
- **State Management**: BLoC Pattern
- **AI/ML**: TensorFlow Lite for on-device analysis
- **APIs**: X (Twitter) API v2, Instagram Graph API
- **Architecture**: Clean Architecture with repository pattern

## Privacy & Security

- **Local Processing**: All analysis happens on-device
- **Secure Storage**: Tokens encrypted with flutter_secure_storage
- **No Data Collection**: Personal social media content never leaves your device
- **Transparent**: Open-source codebase for full transparency

## Contributing

This project aims to combat misinformation and echo chambers through technology. Contributions that improve analysis accuracy, add new features, or enhance user experience are welcome.

## License

This project is created for educational and social awareness purposes.
