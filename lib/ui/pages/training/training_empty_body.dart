import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mci_test/controller/training_controller.dart';

///Page that is displayed when there is no active session.
class TrainingEmptyBody extends StatelessWidget {
  final TrainingController controller = Get.find();
  TrainingEmptyBody({super.key});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(controller.trainingPlan.name),
                      Text("${controller.trainingPlan.duration.toString()} min")
                    ],
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: controller.trainingPlan.exercises.length,
                itemBuilder: (BuildContext context, int index) {
                  final exercise = controller.trainingPlan.exercises[index];
                  return ListTile(
                    title: Text(exercise.name),
                    subtitle: Text(exercise.muscleGroup),
                  );
                }
              ),
            ],
          ),
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {
              controller.createNewSession();
            },
            child: const Text('Start your Session'),
          ),
        ),
      ],
    );
  }
}