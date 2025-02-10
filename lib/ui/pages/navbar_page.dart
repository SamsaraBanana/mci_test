import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mci_test/ui/pages/dashboard/dashboard_page.dart';
import 'package:mci_test/ui/pages/training/training_page.dart';
import '../../controller/nav_controller.dart';

///Bottom NavBar wrapper for the different Pages.
class NavigationScreen extends StatelessWidget {

  final NavigationController navController = Get.put(NavigationController());


  //List of all Pages displayed in the BottomNavigationBar
  final List<Widget> pages = [
    DashboardPage(),
    TrainingPage(),
  ];

  NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[navController.selectedIndex.value]),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          currentIndex: navController.selectedIndex.value,
          onTap: (index) => navController.changePage(index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Dashboard"),
            BottomNavigationBarItem(icon: Icon(Icons.accessibility), label: "Training"),
          ],
        ),
      ),
    );
  }
}
