import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../ui/pages/dashboard/dashboard_page.dart';
import '../ui/pages/login/login_page.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> firebaseUser;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginPage());
    } else {
      Get.offAll(() => DashboardPage());
    }
  }

  void register(String email, String password) async {
    isLoading(true);
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      Get.snackbar('Success', 'Account created!',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Register-Error', e.toString(),
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }


  void login(String email, String password) async {
    isLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar('Success', 'Logged In!',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Login-Error', e.toString(),
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  // Logout
  void logout() async {
    await _auth.signOut();
  }
}
