import 'package:flutter/material.dart';
import 'package:imager/utils/extensions/if_debugging.dart';

import '../../constants/strings.dart';
import 'auth_card.dart';

class PasswordForm extends StatelessWidget {
  const PasswordForm({
    required this.height,
    required this.passwordFocusNode,
    required this.onSaved,
    required this.action,
    required this.onSubmit,
    super.key,
  });
  final double height;
  final FocusNode passwordFocusNode;
  final ValueSave onSaved;
  final TextInputAction action;
  final FieldSubmit onSubmit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        initialValue: "tester".ifDebugging,
        decoration: const InputDecoration(
          labelText: passwordFormLabel,
        ),
        obscureText: true,
        textInputAction: action,
        autocorrect: false,
        onFieldSubmitted: onSubmit,
        focusNode: passwordFocusNode,
        onSaved: onSaved,
        validator: (password) {
          if (password == null || password == "") {
            return passwordEmptyValidator;
          }
          if (password.length < 5) {
            return passwordNotValidValidator;
          }
          return null;
        },
      ),
    );
  }
}
