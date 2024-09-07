import 'package:flutter/material.dart';
import 'package:my_quotes/shared/actions/create_password_dialog.dart';

Future<String?> showCreatePasswordDialog(BuildContext context) =>
    showDialog<String>(
      context: context,
      builder: (context) => const CreatePasswordDialog(),
    );
