import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:try_bloc/views/email_text_field.dart';
import 'package:try_bloc/views/login_button.dart';
import 'package:try_bloc/views/password_text_field.dart';

class LoginView extends HookWidget {
  final OnLoginTap onTap;

  const LoginView({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailCtrl = useTextEditingController();
    final passwordCtrl = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          EmailTextField(controller: emailCtrl),
          PasswordTextField(controller: passwordCtrl),
          LoginButton(
            email: emailCtrl,
            password: passwordCtrl,
            tap: onTap,
          ),
        ],
      ),
    );
  }
}
