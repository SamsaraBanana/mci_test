import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mci_test/ui/components/training/training_countdown_progress_widget.dart';
import 'package:mci_test/ui/components/training/training_textfield_widget.dart';

import '../../../controller/training_controller.dart';
import '../../../model/training_plan/training_session_model.dart';

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
                      const Text("Sets: "),
                      const Expanded(child: SizedBox()),
                      TrainingTextField(controller: trainingController.setsTextController, isLocked: trainingController.enableSetInput.value),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Text("Reps: "),
                      const Expanded(child: SizedBox()),
                      TrainingTextField(controller: trainingController.repsTextController, isLocked: trainingController.enableRepsWeightInput.value,),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Text("Weight: "),
                      const Expanded(child: SizedBox()),
                      TrainingTextField(controller: trainingController.weightTextController, isLocked: trainingController.enableRepsWeightInput.value,),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Text("E1RM: "),
                      const Expanded(child: SizedBox()),
                      Text(trainingController.trainingSession.value!.trainingPlan.exercises[trainingController.trainingSession.value!.currentExerciseIndex].e1RM.toString())
                    ],
                  )
                ],
              ),
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Divider(
                  thickness: 1,
                  color: Colors.grey,
                  endIndent: 10,
                ),
              ),
              Text("Pause Timer"),
              Expanded(
                child: Divider(
                  thickness: 1,
                  color: Colors.grey,
                  indent: 10,
                ),
              ),
            ],
          ),
          const CountdownProgressBar(),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    trainingController.stopExercise();
                    trainingController.cancelCurrentTrainingSession();
                  },
                  child: const Text("Delete", style: TextStyle(color: Colors.red))
              ),
              ///Button to start an Exercise and lock in the selected Set count
              if (trainingController.enableSetInput.value)
                ElevatedButton(
                  onPressed: () {
                    trainingController.startExercise();
                  },
                    child: const Text("Start The Exercise", style: TextStyle(color: Colors.green),)
                ),
              ///Button to start a Set or get to the next Exercise
              if (!trainingController.enableSetInput.value && !trainingController.enableRepsWeightInput.value)
                ElevatedButton(
                  onPressed: () {
                    var currentSetIndex = int.parse(trainingController.setsTextController.text);
                    if (currentSetIndex==0) {
                      trainingController.nextExercise();
                      return;
                    }
                    trainingController.setsTextController.text = (currentSetIndex-1).toString();
                    trainingController.startExerciseSet();
                  },
                  child: Text(
                    trainingController.setsTextController.text == "0" ? "Next Exercise" : "Start Set",
                    style: const TextStyle(color: Colors.green),
                  )
                ),
              ///Button to finish a Set and calculate E1RM
              if(!trainingController.enableSetInput.value && trainingController.enableRepsWeightInput.value)
                ElevatedButton(
                    onPressed: () {
                      trainingController.finishExerciseSet();
                    },
                    child: const Text(
                      "Finish Set",
                      style: TextStyle(color: Colors.green),
                    )
                ),
              ElevatedButton(
                  onPressed: () {
                    //Update the current TrainingSession with the cloud.
                    if(trainingController.trainingSession.value == null)return;
                    TrainingSession updatedSession = trainingController.trainingSession.value!;
                    trainingController.updateTrainingSession(updatedSession);
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.blue),
                  )
              ),
            ],
          )
        ],
      ),
    );
  }
}