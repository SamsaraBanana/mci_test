import 'package:flutter/material.dart';
import 'package:mci_test/model/training_plan/training_plan_model.dart';
import 'package:mci_test/ui/components/training/training_detail_page.dart';

class TrainingPlanCardWidget extends StatelessWidget {
  final TrainingPlan trainingPlan;
  const TrainingPlanCardWidget({super.key, required this.trainingPlan});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Hero(
      tag: trainingPlan.name,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: SizedBox(
          width: double.infinity,
          height: 150,
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrainingDetailPage(plan: trainingPlan),
                    )
                  );
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  title: Text(trainingPlan.name, style: TextStyle(color: colorScheme.surface),),
                  subtitle: Text(trainingPlan.description, style: TextStyle(color: colorScheme.surface),),
                ),
              ),
            ),
          )
        ),
      ),
    );
  }
}