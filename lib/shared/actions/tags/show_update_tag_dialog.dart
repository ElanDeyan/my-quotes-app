import 'package:basics/string_basics.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/shared/widgets/tag_name_field.dart';

Future<String?> showUpdateTagDialog(BuildContext context, Tag tag) {
  return showDialog<String?>(
    context: context,
    builder: (context) => UpdateTagDialog(
      tagName: tag.name,
    ),
  );
}

class UpdateTagDialog extends StatefulWidget {
  const UpdateTagDialog({
    required this.tagName,
    super.key,
  });

  final String tagName;

  @override
  State<UpdateTagDialog> createState() => _UpdateTagDialogState();
}

class _UpdateTagDialogState extends State<UpdateTagDialog> {
  final _updateTagFormKey = GlobalKey<FormState>();

  late final TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    if (widget.tagName.isNotNullOrBlank) {
      _textEditingController = TextEditingController.fromValue(
        TextEditingValue(text: widget.tagName),
      );
    } else {
      _textEditingController = TextEditingController();
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
      title: Text(context.appLocalizations.updateTag),
      content: Form(
        key: _updateTagFormKey,
        autovalidateMode: AutovalidateMode.always,
        child: TagNameField(textEditingController: _textEditingController),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.appLocalizations.delete),
        ),
        TextButton(
          onPressed: () {
            if (_updateTagFormKey.currentState?.validate() ?? false) {
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
