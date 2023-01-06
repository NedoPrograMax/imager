import 'package:flutter/material.dart';
import 'package:imager/utils/extensions/if_debugging.dart';

import '../../constants/strings.dart';
import 'auth_card.dart';

class ConfirmPasswordForm extends StatelessWidget {
  const ConfirmPasswordForm({
    required this.onValidate,
    required this.focusNode,
    super.key,
  });

  final FieldValidate onValidate;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: "tester".ifDebugging,
      decoration: const InputDecoration(
        labelText: passwordConfirmFormLabel,
      ),
      obscureText: true,
      focusNode: focusNode,
      textInputAction: TextInputAction.done,
      autocorrect: false,
      validator: onValidate,
    );
  }
}
