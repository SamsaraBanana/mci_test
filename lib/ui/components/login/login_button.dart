import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String buttonText;

  const LoginButton({super.key, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {  },
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
          buttonText,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}