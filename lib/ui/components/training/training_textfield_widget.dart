import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TrainingTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isLocked;

  const TrainingTextField({
    super.key,
    required this.controller,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75,
      child: TextField(
        controller: controller,
        enabled: isLocked,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value.isEmpty) {
            controller.text = '0';
            controller.selection = const TextSelection.collapsed(offset: 1);
          }
        },
      ),
    );
  }
}