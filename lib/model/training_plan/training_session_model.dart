import 'package:mci_test/model/training_plan/training_plan_model.dart';

class TrainingSession {
  final TrainingPlan trainingPlan;
  int currentExerciseIndex = 0;
  bool isDone = false;

  TrainingSession({
    required this.trainingPlan,
    this.currentExerciseIndex = 0,
    this.isDone = false,
  });

  /// Swaps to next Exercise In the Plan
  /// Returns true if the session is done
  bool nextExercise() {
    if(currentExerciseIndex< trainingPlan.exercises.length-1) {
      currentExerciseIndex++;
      return isDone;
    } else {
      return isDone = true;
    }
  }

  void cancelSession() {
    isDone = true;
  }

  factory TrainingSession.fromJson(Map<String, dynamic> json) {
    return TrainingSession(
      trainingPlan: TrainingPlan.fromJson(json['trainingPlan']),
      currentExerciseIndex: json['currentExerciseIndex'] ?? 0,
      isDone: json['isDone'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trainingPlan': trainingPlan.toJson(),
      'currentExerciseIndex': currentExerciseIndex,
      'isDone': isDone,
    };
  }
}