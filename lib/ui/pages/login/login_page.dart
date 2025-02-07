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
        title: const Text('MCI TEST DEMO APP'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Obx(
              ()=> Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 60),
                    child: Text(
                      loginController.isRegister.value
                          ? "Register Now"
                          : "Login Now",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: LoginTextField(
                      obscureText: false,
                      controller: loginController.usernameController,
                      formKey: loginController.formKeyUsername,
                      validator: loginController.validateUsername,
                      decoration: usernameTextFieldDecoration("Username"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: LoginTextField(
                      obscureText: true,
                      controller: loginController.passwordController,
                      formKey: loginController.formKeyPassword,
                      validator: loginController.validatePassword,
                      decoration: passwordTextFieldDecoration("Password"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Visibility(
                      visible: loginController.isRegister.value,
                      child: LoginTextField(
                        obscureText: true,
                        controller: loginController.confirmPasswordController,
                        formKey: loginController.formKeyConfirmPassword,
                        validator: loginController.validateConfirmPassword,
                        decoration: passwordTextFieldDecoration("ConfirmPassword"),
                      ),
                    ),
                  ),
                  LoginButton(isRegistering: loginController.isRegister.value),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RegisterLink(isRegistering: loginController.isRegister.value),
                  )
                ],
              ),
            ),
          ),
        )
      ),
      bottomSheet: const LoginBottomSheet(),
    );
  }
}

