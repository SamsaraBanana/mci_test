import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';
import '../../../controller/nav_controller.dart';
import '../../../controller/training_controller.dart';
import '../../components/training/training_card_widget.dart';

class DashboardPage extends StatelessWidget {
  final AuthController authController = Get.find();
  final TrainingController trainingController = Get.find();
  final NavigationController navigationController = Get.find();

  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            authController.logout();
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: trainingController.getActiveSession,
        child: Obx(() =>
           ListView(
              children: [
                if (trainingController.trainingSession.value != null)
                  GestureDetector(
                    onTap: () {
                      navigationController.changePage(1);
                    },
                    child: TrainingPlanCardWidget(trainingSession: trainingController.trainingSession.value!)
                  )
                else const Center(child: Text("No active Session")),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                        endIndent: 10, // Abstand zum Text
                      ),
                    ),
                    Text("History"),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                        indent: 10, // Abstand zum Text
                      ),
                    ),
                  ],
                ),
                FutureBuilder(
                  future: trainingController.getTrainingSessionsHistory(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState== ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.hasError}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No Completes Session Found'));
                    } else {
                      final sessions = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: sessions.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TrainingPlanCardWidget(trainingSession: sessions[index]),
                          );
                        }
                      );
                    }
                  }
                )
              ]
           ),
        )
      ),
    );
  }
}
