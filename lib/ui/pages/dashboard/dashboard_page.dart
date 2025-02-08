import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';

class DashboardPage extends StatelessWidget {
  final AuthController authController = Get.find();

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
      body: Center(child: Text('Your logged in as ${authController.firebaseUser.value?.email}')),
    );
  }
}
