import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_progress.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppInitial()) {
    on<LoadUserProgress>(_onLoadUserProgress);
    on<UpdatePoints>(_onUpdatePoints);
    on<CompleteQuest>(_onCompleteQuest);
    on<AddBadge>(_onAddBadge);
  }

  Future<void> _onLoadUserProgress(LoadUserProgress event, Emitter<AppState> emit) async {
    try {
      // For local testing, just load initial progress
      emit(AppLoaded(UserProgress.initial()));
    } catch (e) {
      emit(AppError(e.toString()));
    }
  }

  Future<void> _onUpdatePoints(UpdatePoints event, Emitter<AppState> emit) async {
    if (state is AppLoaded) {
      final updatedProgress = (state as AppLoaded).progress.copyWith(
        points: (state as AppLoaded).progress.points + event.points
      );
      emit(AppLoaded(updatedProgress));
    }
  }

  Future<void> _onCompleteQuest(CompleteQuest event, Emitter<AppState> emit) async {
    if (state is AppLoaded) {
      final currentProgress = (state as AppLoaded).progress;
      final updatedQuests = [...currentProgress.completedQuests, event.questId];
      
      final updatedProgress = currentProgress.copyWith(
        completedQuests: updatedQuests,
        points: currentProgress.points + event.points
      );
      emit(AppLoaded(updatedProgress));
    }
  }

  Future<void> _onAddBadge(AddBadge event, Emitter<AppState> emit) async {
    if (state is AppLoaded) {
      final currentProgress = (state as AppLoaded).progress;
      final updatedBadges = [...currentProgress.badges, event.badgeId];
      
      final updatedProgress = currentProgress.copyWith(badges: updatedBadges);
      emit(AppLoaded(updatedProgress));
    }
  }
}
