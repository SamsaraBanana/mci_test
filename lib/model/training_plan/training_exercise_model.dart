import 'dart:math';

class Exercise {
  final String name;
  final int sets;
  final int reps;
  final String repUnit;
  final int weight;
  final String weightUnit;
  final int breakTime;
  final String muscleGroup;
  final List<String> equipment;
  late double? e1RM;
  late bool isCompleted;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.repUnit,
    required this.weight,
    required this.weightUnit,
    required this.breakTime,
    required this.muscleGroup,
    required this.equipment,
    this.e1RM = 0.0,
    this.isCompleted = false,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      sets: json['sets'],
      reps: json['reps'],
      repUnit: json['repUnit'],
      weight: json['weight'],
      weightUnit: json['weightUnit'],
      breakTime: json['break'],
      muscleGroup: json['muscleGroup'],
      equipment: List<String>.from(json['equipment']),
      e1RM: json['e1RM'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sets': sets,
      'reps': reps,
      'repUnit': repUnit,
      'weight': weight,
      'weightUnit': weightUnit,
      'break': breakTime,
      'muscleGroup': muscleGroup,
      'equipment': equipment,
      'e1RM': e1RM,
      'isCompleted': isCompleted,
    };
  }

  double calculateE1RM(int weight, int reps) {
    if (weight <= 0 || reps <= 0) {
      return 0.0;
    }
    double result = (100 * weight) / (52.2 + (41.9 * pow(e, -0.055 * reps)));
    return e1RM = double.parse(result.toStringAsFixed(2));
  }
}
