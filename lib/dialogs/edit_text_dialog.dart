import 'package:flutter/material.dart';

Future<String?> showEditTextDialog<String>(
  BuildContext context,
  String initialText,
) {
  return showDialog(
      context: context,
      builder: (ctx) => Dialog(
            child: TextFormField(
              initialValue: "$initialText",
              decoration: const InputDecoration(labelText: "New text"),
              onFieldSubmitted: (value) => Navigator.of(ctx).pop(value),
            ),
          ));
}
