import 'package:flutter/material.dart';
import 'package:my_quotes/shared/widgets/form/enter_password_dialog.dart';

Future<String?> showEnterPasswordDialog(BuildContext context) =>
    showDialog<String>(
      context: context,
      builder: (context) => const EnterPasswordDialog(),
    );
