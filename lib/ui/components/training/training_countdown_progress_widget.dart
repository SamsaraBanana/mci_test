import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/training_controller.dart';

///Widget for the pause timer.
class CountdownProgressBar extends GetView<TrainingController> {
  const CountdownProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: LinearProgressIndicator(
          value: controller.isPaused.value ? controller.progressValue.value : 1.0,
          backgroundColor: Colors.grey[300],
          color: Colors.blue,
        ),
      );
    });
  }
}
