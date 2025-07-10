import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/app_bloc.dart';
import 'screens/analyzer_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (you'll need to run `flutterfire configure` first)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Firebase initialization failed: $e');
    // Continue without Firebase for now
  }
  
  runApp(const PerspectiveQuestApp());
}

class PerspectiveQuestApp extends StatelessWidget {
  const PerspectiveQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc()..add(LoadUserProgress()),
      child: MaterialApp(
        title: 'Perspective Quest',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
        ),
        home: const AnalyzerScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
