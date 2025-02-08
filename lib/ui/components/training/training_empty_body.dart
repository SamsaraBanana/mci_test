import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mci_test/controller/training_controller.dart';

class TrainingEmptyBody extends StatelessWidget {
  final TrainingController controller = Get.find();
  TrainingEmptyBody({super.key});


  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 100),
        const Center(child: Text('No Active Session found.')),
        const SizedBox(height: 20),
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