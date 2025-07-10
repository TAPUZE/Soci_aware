part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();
}

class LoadUserProgress extends AppEvent {
  @override
  List<Object> get props => [];
}

class UpdatePoints extends AppEvent {
  final int points;
  const UpdatePoints(this.points);
  @override
  List<Object> get props => [points];
}

class CompleteQuest extends AppEvent {
  final String questId;
  final int points;
  const CompleteQuest(this.questId, this.points);
  @override
  List<Object> get props => [questId, points];
}

class AddBadge extends AppEvent {
  final String badgeId;
  const AddBadge(this.badgeId);
  @override
  List<Object> get props => [badgeId];
}
