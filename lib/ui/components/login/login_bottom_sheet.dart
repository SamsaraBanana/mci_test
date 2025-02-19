import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';
import '../../../controller/auth_controller.dart';

///Bottom Sheet in the login screen that displays Google Sign in.
///It could also display Apple Sign In (Not Implemented).
class LoginBottomSheet extends StatelessWidget {
  const LoginBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find();
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(50)
          ),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, -2)
            )
          ]
      ),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 10, right: 10),
            child: Row(
              children: [
                Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Theme.of(context).primaryColorDark,
                    )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'or',
                    style: TextStyle(color: Theme.of(context).primaryColorDark),
                  ),
                ),
                Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Theme.of(context).primaryColorDark,
                    )
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: SignInButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                ),
                Buttons.google,
                onPressed: () {
                  controller.signInWithGoogle();
                }
            ),
          ),
          if(false) //TODO: Add Apple Sign In
            SizedBox(
              width: double.infinity,
              child: SignInButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  Buttons.apple,
                  onPressed: () {}
              ),
            )
        ],
      ),
    );
  }
}