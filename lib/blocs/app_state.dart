part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();
}

class AppInitial extends AppState {
  const AppInitial();
  @override
  List<Object> get props => [];
}

class AppLoaded extends AppState {
  final UserProgress progress;
  const AppLoaded(this.progress);
  @override
  List<Object> get props => [progress];
}

class AppError extends AppState {
  final String message;
  const AppError(this.message);
  @override
  List<Object> get props => [message];
}
