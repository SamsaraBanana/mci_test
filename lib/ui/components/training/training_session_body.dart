import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mci_test/ui/components/training/training_textfield.dart';

import '../../../controller/training_controller.dart';

class TrainingSessionBody extends StatelessWidget {
  const TrainingSessionBody({super.key});

  @override
  Widget build(BuildContext context) {
    final trainingController = Get.find<TrainingController>();

    return Obx(() => Column(
        children: [
          ListTile(
            title: Text(trainingController.trainingSession.value!.trainingPlan.name),
            subtitle: Text(trainingController.trainingSession.value!.trainingPlan.exercises[trainingController.trainingSession.value!.currentExerciseIndex].name),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Sets: "),
                      Expanded(child: SizedBox()),
                      TrainingTextField(controller: trainingController.setsController),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text("Reps: "),
                      Expanded(child: SizedBox()),
                      TrainingTextField(controller: trainingController.repsController),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text("Weight: "),
                      Expanded(child: SizedBox()),
                      TrainingTextField(controller: trainingController.weightController),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text("E1RM: "),
                      Expanded(child: SizedBox()),
                      Text(trainingController.trainingSession.value!.trainingPlan.exercises[trainingController.trainingSession.value!.currentExerciseIndex].e1RM.toString())
                    ],
                  )
                ],
              ),
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    trainingController.cancelCurrentTrainingSession();
                  },
                  child: Text("Cancel")
              ),
              ElevatedButton(
                onPressed: () {
                  trainingController.startExercise();
                },
                child: Text("Start")
              ),
              ElevatedButton(
                  onPressed: () {
                    trainingController.nextExercise();
                  },
                  child: Text("Next")
              ),


            ],
          )
        ],
      ),
    );
  }
}