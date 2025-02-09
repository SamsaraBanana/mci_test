import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mci_test/model/training_plan/training_session_model.dart';
import 'package:mci_test/ui/pages/training/training_detail_page.dart';

import '../../../controller/nav_controller.dart';

class TrainingPlanCardWidget extends StatelessWidget {
  final TrainingSession trainingSession;
  const TrainingPlanCardWidget({super.key, required this.trainingSession});

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController = Get.find();
    final colorScheme = Theme.of(context).colorScheme;
    return Hero(
      tag: trainingSession.hashCode,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.inverseSurface,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: InkWell(
              onLongPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrainingDetailPage(session: trainingSession),
                  )
                );
              },
              onTap: () {
                if(!trainingSession.isDone) navigationController.changePage(1);
              },
              child: ListTile(
                contentPadding: const EdgeInsets.all(15),
                title: Text(trainingSession.trainingPlan.name, style: TextStyle(color: colorScheme.surface),),
                subtitle: Text(trainingSession.trainingPlan.description, style: TextStyle(color: colorScheme.surface),),
              ),
            ),
          ),
        ),
      ),
    );
  }
}