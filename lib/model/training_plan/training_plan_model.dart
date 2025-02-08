import 'package:mci_test/model/training_plan/training_exercise_model.dart';

class TrainingPlan {
  final String name;
  final String description;
  final int duration;
  final String category;
  final String split;
  final List<Exercise> exercises;

  TrainingPlan({
    required this.name,
    required this.description,
    required this.duration,
    required this.category,
    required this.split,
    required this.exercises,
  });

  factory TrainingPlan.fromJson(Map<String, dynamic> json) {
    return TrainingPlan(
      name: json['name'],
      description: json['description'],
      duration: json['duration'],
      category: json['category'],
      split: json['split'],
      exercises: (json['exercises'] as List).map((e) => Exercise.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'duration': duration,
      'category': category,
      'split': split,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }
}
