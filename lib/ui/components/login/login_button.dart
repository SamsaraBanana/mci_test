import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/login_controller.dart';

class LoginButton extends StatelessWidget {
  final bool isRegistering;

  const LoginButton({super.key, required this.isRegistering});

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.put(LoginController());
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          isRegistering? controller.registerEmail() :
          controller.loginEmail();
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