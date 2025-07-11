import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/app_bloc.dart';
import 'screens/analyzer_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Run without Firebase for now to test locally
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
