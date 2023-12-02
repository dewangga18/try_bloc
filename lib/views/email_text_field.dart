import 'package:flutter/material.dart';
import 'package:try_bloc/strings.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController controller;

  const EmailTextField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: const InputDecoration(hintText: hintEmailText),
      textInputAction: TextInputAction.next,
    );
  }
}
