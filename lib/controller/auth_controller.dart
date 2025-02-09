import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../ui/pages/login/login_page.dart';
import '../ui/pages/navbar_page.dart';

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

  ///Set Initial Screen && when userStatus changes
  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginPage());
    } else {
      Get.offAll(() => NavigationScreen());
    }
  }

  ///Register with Email via Firebase
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

  ///Login with Email via Firebase
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

  ///Login with Google via Firebase
  void signInWithGoogle() async {
    isLoading(true);
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential user = await FirebaseAuth.instance.signInWithCredential(credential);

      firebaseUser(user.user);

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
