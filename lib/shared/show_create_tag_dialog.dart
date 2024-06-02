import 'package:basics/basics.dart';
import 'package:flutter/material.dart';

Future<String?>? showCreateTagDialog(
  BuildContext context, [
  String? initialValue,
]) async {
  return await showDialog<String?>(
    context: context,
    builder: (context) {
      late final TextEditingController textEditingController;

      if (initialValue.isNullOrBlank) {
        textEditingController = TextEditingController();
      } else {
        textEditingController = TextEditingController(text: initialValue);
      }

      final createTagFormKey = GlobalKey<FormState>();
      return AlertDialog(
        title: const Text('Create tag'),
        content: Form(
          key: createTagFormKey,
          autovalidateMode: AutovalidateMode.always,
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Tag name',
            ),
            controller: textEditingController,
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
            onPressed: () => Navigator.pop(
              context,
              textEditingController.text,
            ),
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
