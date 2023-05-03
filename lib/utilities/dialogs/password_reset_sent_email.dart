import 'package:flutter/cupertino.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentEmail(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Reset Password',
    content: 'Check your email!',
    optionsBuilder: () => {
      'ok': null,
    },
  );
}
