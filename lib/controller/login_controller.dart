import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey formKeyUsername = GlobalKey<FormState>();
  final GlobalKey formKeyPassword = GlobalKey<FormState>();
  final GlobalKey formKeyConfirmPassword = GlobalKey<FormState>();

  var isEmailLogin = false.obs;
  var isRegister = false.obs;


  bool isPasswordConfirmed() {
    return passwordController.text == confirmPasswordController.text;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'usernameEmptyError'; // Error for empty username
    } else if (value.startsWith('.')) {
      return 'usernamePeriodErrorStart'; // Error if username starts or ends with a period
    } else if (value.endsWith('.')) {
      return 'usernamePeriodErrorEnd'; // Error for invalid characters
    } else if (!RegExp(r'^[a-zA-Z0-9_.]+$').hasMatch(value)) {
      return 'usernameInvalidError'; // Error for invalid characters
    } else if (value.length > 30) {
      return 'usernameLengthError'; // Error if username is too long
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'passwordEmptyError';
    } else if (value.length < 8) {
      return 'passwordLengthError';
    } else if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'passwordCapitalLetterError';
    } else if (!value.contains(RegExp(r'[a-z]'))) {
      return 'passwordNormalLetterError';
    } else if (!value.contains(RegExp(r'[0-9]'))) {
      return 'passwordNumberError';
    } else if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'passwordSpecialError';
    }
    return null;
  }

  void toggleEmailLogin() => isEmailLogin.toggle();
  void toggleRegister() => isRegister.toggle();

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}