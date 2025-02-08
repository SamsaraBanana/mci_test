import 'package:flutter/material.dart';
import 'package:mci_test/ui/components/training/trainingDetailAppBarWidget.dart';

import '../../../model/training_plan/training_plan_model.dart';
import 'exercise_widget.dart';

class TrainingDetailPage extends StatefulWidget {
  final TrainingPlan plan;
  const TrainingDetailPage({super.key, required this.plan});

  @override
  State<TrainingDetailPage> createState() => _TrainingDetailPageState();
}

class _TrainingDetailPageState extends State<TrainingDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TrainingDetailAppBar(title: widget.plan.name, heroTag: widget.plan.name),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.plan.exercises.length,
              itemBuilder: (context, index) {
                final exercise = widget.plan.exercises[index];
                return ExerciseWidget(exercise: exercise);
              },
            ),
          ),
        ],
      ),
    );
  }
}