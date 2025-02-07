import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/auth_controller.dart';
import '../../../controller/login_controller.dart';


///Login button that checks the InputFields and blocks if the Auth State is loading.
class LoginButton extends StatelessWidget {
  final bool isRegistering;

  const LoginButton({super.key, required this.isRegistering});

  @override
  Widget build(BuildContext context) {
    LoginController loginController = Get.find();
    AuthController authController = Get.find();
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (loginController.validateInputs()&&authController.isLoading.value == false) {
            isRegistering
                ? authController.register(loginController.emailController.text, loginController.passwordController.text)
                : authController.login(loginController.emailController.text, loginController.passwordController.text);
          }
        },
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            shadowColor: Colors.grey,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15)
        ),
        child: Text(
          isRegistering? "Register" : "Login",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}