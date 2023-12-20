import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionBuilder,
}) {
  final opions = optionBuilder();
  return showDialog<T?>(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: opions.keys.map((opr) {
          final value = opions[opr];

          return TextButton(
            onPressed: () { 
              if (value != null) {
                Navigator.pop(context, value);
              } else {
                Navigator.pop(context);
              }
            },
            child: Text(opr),
          );
        }).toList(),
      );
    },
  );
}
