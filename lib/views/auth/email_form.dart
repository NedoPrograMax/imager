import 'package:flutter/material.dart';
import 'package:imager/utils/extensions/if_debugging.dart';

import '../../constants/strings.dart';
import 'auth_card.dart';

class EmailForm extends StatelessWidget {
  const EmailForm({
    required this.height,
    required this.onSubmit,
    required this.onSaved,
    super.key,
  });
  final double height;

  final ValueSave onSaved;
  final FieldSubmit onSubmit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        initialValue: "test@test.com".ifDebugging,
        decoration: const InputDecoration(
          labelText: emailFormLabel,
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        autocorrect: false,
        onFieldSubmitted: onSubmit,
        onSaved: onSaved,
        validator: (email) {
          if (email == null || email == "") {
            return emailEmptyValidator;
          }
          if (!email.contains("@") ||
              !email.contains(".") ||
              email.length < 5) {
            return emailNotValidValidator;
          }
          return null;
        },
      ),
    );
  }
}
