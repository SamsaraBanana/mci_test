import 'package:flutter/material.dart';
import 'package:mci_test/model/training_plan/training_session_model.dart';
import 'package:mci_test/ui/components/training/training_detail_appbar_widget.dart';
import '../../components/training/exercise_widget.dart';

///The training session detail page that displays details fot each exercise.
class TrainingDetailPage extends StatefulWidget {
  final TrainingSession session;
  const TrainingDetailPage({super.key, required this.session});

  @override
  State<TrainingDetailPage> createState() => _TrainingDetailPageState();
}

class _TrainingDetailPageState extends State<TrainingDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TrainingDetailAppBar(title: widget.session.trainingPlan.name, heroTag: widget.session.hashCode),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.session.trainingPlan.exercises.length,
              itemBuilder: (context, index) {
                final exercise = widget.session.trainingPlan.exercises[index];
                return ExerciseWidget(exercise: exercise);
              },
            ),
          ),
        ],
      ),
    );
  }
}