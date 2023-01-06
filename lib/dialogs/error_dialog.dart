import 'package:flutter/cupertino.dart';
import 'package:imager/constants/strings.dart';
import 'package:imager/dialogs/generic_dialog.dart';
import 'package:imager/models/exception/exception.dart';

Future<void> showErrorDialog(BuildContext context, GenericException exception) {
  return showGenericDialog(
    context: context,
    title: exception.title,
    content: exception.message,
    options: {optionOk: null},
  );
}
