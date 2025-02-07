import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKeyEmail = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyPassword = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyConfirmPassword = GlobalKey<FormState>();

  var isRegister = false.obs;


  bool isPasswordConfirmed() {
    return passwordController.text == confirmPasswordController.text;
  }

  ///Simple Email validator
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your E-Mail';
    }
    final RegExp emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid E-Mail';
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

  ///Validates User input before sending to Firebase
  bool validateInputs() {
    if (isRegister.value) {
      if (
        formKeyEmail.currentState!.validate() &&
        formKeyPassword.currentState!.validate() &&
        formKeyConfirmPassword.currentState!.validate()
      ) return true;
    }else {
      if (
        formKeyEmail.currentState!.validate() &&
        formKeyPassword.currentState!.validate()
      ) return true;
    }
    return false;
  }


  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}