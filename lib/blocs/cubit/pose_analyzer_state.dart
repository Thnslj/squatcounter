part of 'pose_analyzer_cubit.dart';

@immutable
abstract class PoseAnalyzeState {}

class PoseAnalyzerInitial extends PoseAnalyzeState {}

class PoseAnalyzerReady extends PoseAnalyzeState {}

enum PoseResult { squatting, standing, none }

class PoseAnalyzeResult extends PoseAnalyzeState {
  final PoseResult squatAnalyze;

  PoseAnalyzeResult(this.squatAnalyze);
}
