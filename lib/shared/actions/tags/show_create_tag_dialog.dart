import 'package:basics/basics.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/shared/widgets/tag_name_field.dart';

Future<String?>? showCreateTagDialog(
  BuildContext context, [
  String? initialValue,
]) async {
  return await showDialog<String?>(
    context: context,
    builder: (context) {
      return CreateTagDialog(
        initialValue: initialValue,
      );
    },
  );
}

class CreateTagDialog extends StatefulWidget {
  const CreateTagDialog({
    super.key,
    required this.initialValue,
  });

  final String? initialValue;

  @override
  State<CreateTagDialog> createState() => _CreateTagDialogState();
}

class _CreateTagDialogState extends State<CreateTagDialog> {
  final GlobalKey<FormState> _createTagFormKey = GlobalKey<FormState>();

  late final TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue.isNullOrBlank) {
      _textEditingController = TextEditingController();
    } else {
      _textEditingController = TextEditingController.fromValue(
        TextEditingValue(text: widget.initialValue!),
      );
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.appLocalizations.createTag),
      content: Form(
        key: _createTagFormKey,
        autovalidateMode: AutovalidateMode.always,
        child: TagNameField(textEditingController: _textEditingController),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.appLocalizations.cancel),
        ),
        TextButton(
          onPressed: () {
            if (_createTagFormKey.currentState?.validate() ?? false) {
              Navigator.pop(
                context,
                removeDiacritics(_textEditingController.text.trim()),
              );
            }
          },
          child: Text(context.appLocalizations.save),
        ),
      ],
    );
  }
}
