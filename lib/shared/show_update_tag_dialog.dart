import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';

Future<String?> showUpdateTagDialog(BuildContext context, Tag tag) {
  final textEditingController =
      TextEditingController.fromValue(TextEditingValue(text: tag.name));
  final updateTagFormKey = GlobalKey<FormState>();
  return showDialog<String?>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Update tag'),
      content: Form(
        key: updateTagFormKey,
        autovalidateMode: AutovalidateMode.always,
        child: TextFormField(
          controller: textEditingController,
          decoration: const InputDecoration(
            labelText: 'New tag name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value.isNullOrBlank) {
              return "Can't be empty";
            }

            if (value.isNotNullOrBlank && value!.contains(',')) {
              return 'Commas are disallowed';
            }

            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (updateTagFormKey.currentState?.validate() ?? false) {
              Navigator.pop(context, textEditingController.text);
            }
          },
          child: const Text('Update'),
        ),
      ],
    ),
  );
}
