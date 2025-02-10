import 'package:flutter/material.dart';
import 'package:mci_test/model/training_plan/training_exercise_model.dart';

///Widget that displays exercises in the detail panel.
class ExerciseWidget extends StatelessWidget {
  final Exercise exercise;
  const ExerciseWidget({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text(exercise.name)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEditableField(context, "Sets", exercise.sets.toString()),
                  _buildEditableField(context, "Reps", exercise.reps.toString(), suffix: exercise.repUnit),
                  _buildEditableField(context, "Weight", exercise.weight.toString(), suffix: exercise.weightUnit),
                ],
              ),
              Text("E1RM: ${exercise.e1RM}"),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildEditableField(BuildContext context, String label, String initialValue, {String suffix = ""}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text("$label: "),
          SizedBox(
            width: 60,
            height: 35,
            child: TextField(
              enabled: false,
              controller: TextEditingController(text: initialValue),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
              ),
              onSubmitted: (value) {
                print("$label updated to: $value");
              },
            ),
          ),
          if (suffix.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(suffix),
          ]
        ],
      ),
    );
  }

}