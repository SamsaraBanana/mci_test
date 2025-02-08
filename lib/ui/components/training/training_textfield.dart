import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/training_controller.dart';

class TrainingTextField extends StatelessWidget {
  final TextEditingController controller;

  const TrainingTextField(
    {
      super.key,
      required this.controller,
    }
  );

  @override
  Widget build(BuildContext context) {
    final trainingController = Get.find<TrainingController>();
    return Obx(
      () => SizedBox(
        width: 75,
        child: TextFormField(
          controller: controller,
          enabled: trainingController.isLocked.value,
          keyboardType: TextInputType.number
        ),
      ),
    );
  }
}