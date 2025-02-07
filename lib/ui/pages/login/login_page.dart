import 'package:flutter/material.dart';
import 'package:mci_test/ui/components/login/login_button.dart';
import 'package:mci_test/ui/components/login/login_register_link.dart';
import 'package:mci_test/ui/components/login/login_textfield.dart';
import '../../../controller/login_controller.dart';
import '../../components/login/login_bottom_sheet.dart';
import 'package:get/get.dart';


class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Welcome'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(
            ()=> Column(
              children: [
                LoginTextField(
                  obscureText: false,
                  controller: loginController.usernameController,
                  formKey: loginController.formKeyUsername,
                  validator: loginController.validateUsername,
                  decoration: usernameTextFieldDecoration("Username"),
                ),
                LoginTextField(
                  obscureText: true,
                  controller: loginController.passwordController,
                  formKey: loginController.formKeyPassword,
                  validator: loginController.validatePassword,
                  decoration: passwordTextFieldDecoration("Password"),
                ),
                Visibility(
                  visible: loginController.isRegister.value,
                  child: LoginTextField(
                    obscureText: true,
                    controller: loginController.confirmPasswordController,
                    formKey: loginController.formKeyConfirmPassword,
                    validator: loginController.validatePassword,
                    decoration: passwordTextFieldDecoration("ConfirmPassword"),
                  ),
                ),
                LoginButton(buttonText: "Continue"),
                RegisterLink(isRegistering: loginController.isRegister.value)
              ],
            ),
          ),
        )
      ),
      bottomSheet: const LoginBottomSheet(),
    );
  }
}

