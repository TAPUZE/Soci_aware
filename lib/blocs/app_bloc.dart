import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_progress.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppBloc() : super(const AppInitial()) {
    on<LoadUserProgress>(_onLoadUserProgress);
    on<UpdatePoints>(_onUpdatePoints);
    on<CompleteQuest>(_onCompleteQuest);
    on<AddBadge>(_onAddBadge);
  }

  Future<void> _onLoadUserProgress(LoadUserProgress event, Emitter<AppState> emit) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          emit(AppLoaded(UserProgress.fromMap(doc.data() as Map<String, dynamic>)));
        } else {
          await _firestore.collection('users').doc(user.uid).set(UserProgress.initial().toMap());
          emit(AppLoaded(UserProgress.initial()));
        }
      } else {
        emit(AppLoaded(UserProgress.initial()));
      }
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  Future<void> _onUpdatePoints(UpdatePoints event, Emitter<AppState> emit) async {
    User? user = _auth.currentUser;
    if (user != null && state is AppLoaded) {
      await _firestore.collection('users').doc(user.uid).update({'points': FieldValue.increment(event.points)});
      final updatedProgress = (state as AppLoaded).progress.copyWith(
        points: (state as AppLoaded).progress.points + event.points
      );
      emit(AppLoaded(updatedProgress));
    }
  }

  Future<void> _onCompleteQuest(CompleteQuest event, Emitter<AppState> emit) async {
    User? user = _auth.currentUser;
    if (user != null && state is AppLoaded) {
      final currentProgress = (state as AppLoaded).progress;
      final updatedQuests = [...currentProgress.completedQuests, event.questId];
      
      await _firestore.collection('users').doc(user.uid).update({
        'completedQuests': updatedQuests,
        'points': FieldValue.increment(event.points)
      });
      
      final updatedProgress = currentProgress.copyWith(
        completedQuests: updatedQuests,
        points: currentProgress.points + event.points
      );
      emit(AppLoaded(updatedProgress));
    }
  }

  Future<void> _onAddBadge(AddBadge event, Emitter<AppState> emit) async {
    User? user = _auth.currentUser;
    if (user != null && state is AppLoaded) {
      final currentProgress = (state as AppLoaded).progress;
      final updatedBadges = [...currentProgress.badges, event.badgeId];
      
      await _firestore.collection('users').doc(user.uid).update({
        'badges': updatedBadges
      });
      
      final updatedProgress = currentProgress.copyWith(badges: updatedBadges);
      emit(AppLoaded(updatedProgress));
    }
  }
}
