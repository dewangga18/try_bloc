import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:try_bloc/bloc/app_bloc.dart';
import 'package:try_bloc/bloc/app_event.dart';
import 'package:try_bloc/bloc/app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends HookWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailCtrl = useTextEditingController(
      text: 'aaronevanjulio18@gmail.com'.ifDebugging,
    );
    final passwordCtrl = useTextEditingController(
      text: 'learningBloc'.ifDebugging,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                hintText: 'Input your email...',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordCtrl,
              decoration: const InputDecoration(
                hintText: 'Input your password...',
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              obscuringCharacter: '*',
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                final email = emailCtrl.text;
                final password = passwordCtrl.text;
                context.read<AppBloc>().add(
                      AppEventLogin(email: email, password: password),
                    );
              },
              child: const Text('Log in'),
            ),
            TextButton(
              onPressed: () {
                context.read<AppBloc>().add(AppEventGoToRegistration());
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
