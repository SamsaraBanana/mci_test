import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/login_controller.dart';

class RegisterLink extends StatelessWidget {
  final bool isRegistering;
  const RegisterLink(
    {
      super.key,
      required this.isRegistering
    }
  );

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          isRegistering
            ? "Already a Member? "
            : "Not a Member? ",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        InkWell(
          onTap: () {
            Get.put(LoginController()).toggleRegister();
          },
          child: Text(
            isRegistering
              ? "Login now"
              : "Register now",
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.bold
            ) ,
          )
        )
      ],
    );
  }

}