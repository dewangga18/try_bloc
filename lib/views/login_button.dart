import 'package:flutter/material.dart';
import 'package:try_bloc/dialogs/generic_dialog.dart';
import 'package:try_bloc/strings.dart';

typedef OnLoginTap = void Function(String email, String password);

class LoginButton extends StatelessWidget {
  final TextEditingController email;
  final TextEditingController password;
  final OnLoginTap tap;

  const LoginButton({
    Key? key,
    required this.email,
    required this.password,
    required this.tap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (email.text.isEmpty || password.text.isEmpty) {
          showGenericDialog<bool>(
            context: context,
            title: emailOrPasswordEmptyTitle,
            content: emailOrPasswordEmptyDesc,
            optionBuilder: () => {ok: true},
          );
        } else {
          tap(email.text, password.text);
        }
      },
      child: const Text(login),
    );
  }
}
