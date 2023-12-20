
import 'package:flutter/material.dart';
import 'package:try_bloc/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete',
    content: 'Are you user for delete this account',
    optionBuilder: () => {
      'Cancel': false,
      'Delete Account': true,
    },
  ).then((value) => value ?? false);
}

