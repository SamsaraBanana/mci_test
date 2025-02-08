import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/training_controller.dart';
import '../../components/training/training_empty_body.dart';
import '../../components/training/training_session_body.dart';

class TrainingPage extends StatelessWidget {
  final trainingController = Get.put(TrainingController());
  TrainingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Training'),
          centerTitle: true,
        ),
        body: Obx(() {
          if (trainingController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
              onRefresh: trainingController.getActiveSession,
              child: trainingController.trainingSession.value == null
                  ? TrainingEmptyBody()
                  : TrainingSessionBody()
          );
        }),
      ),
    );
  }
}