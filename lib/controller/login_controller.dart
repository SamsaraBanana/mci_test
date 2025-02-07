import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKeyUsername = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyPassword = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyConfirmPassword = GlobalKey<FormState>();

  var isRegister = false.obs;


  bool isPasswordConfirmed() {
    return passwordController.text == confirmPasswordController.text;
  }

  ///Validates Username for Syntax that could be problematic
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

  ///Validates the Password for common weaknesses
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

  ///Validates if the ConfirmPassword is the same as the Password
  String? validateConfirmPassword(String? value) {
    String? passwordError = validatePassword(value);
    if (passwordError == null) {
      if(isPasswordConfirmed()) {
        return null;
      }
      else {
        return 'passwordConfirmError';
      }
    }
    return passwordError;
  }

  void toggleRegister() => isRegister.toggle();

  ///Login via Firebase Auth Email system
  void loginEmail() {
    if (formKeyUsername.currentState!.validate() && formKeyPassword.currentState!.validate() && !isRegister.value) {
      // Perform login logic here
    }
  }

  ///Register via Firebase Auth Email system
  void registerEmail() {
    if (
      formKeyUsername.currentState!.validate() &&
      formKeyPassword.currentState!.validate() &&
      formKeyConfirmPassword.currentState!.validate() &&
      isRegister.value && isPasswordConfirmed()
    ) {

    }
  }

  //TODO Google Sign in
  void googleSignIn() {
    throw UnimplementedError();
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}