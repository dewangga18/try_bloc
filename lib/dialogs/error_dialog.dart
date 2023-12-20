import 'package:flutter/material.dart';
import 'package:try_bloc/auth/auth_error.dart';
import 'package:try_bloc/dialogs/generic_dialog.dart';

Future<void> showAuthErorDialog({
  required BuildContext context,
  required AuthError error,
}) {
  return showGenericDialog<void>(
    context: context,
    title: error.errorTitle,
    content: error.errorText,
    optionBuilder: () => {
      'OK': true,
    },
  );
}
