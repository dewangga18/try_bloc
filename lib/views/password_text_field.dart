import 'package:flutter/material.dart';
import 'package:try_bloc/strings.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;

  const PasswordTextField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      obscuringCharacter: '~',
      decoration: const InputDecoration(hintText: hintPasswordText),
    );
  }
}
