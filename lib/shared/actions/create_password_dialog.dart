import 'package:basics/basics.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/shared/widgets/gap.dart';

class CreatePasswordDialog extends StatefulWidget {
  const CreatePasswordDialog({
    super.key,
  });

  @override
  State<CreatePasswordDialog> createState() => _CreatePasswordDialogState();
}

class _CreatePasswordDialogState extends State<CreatePasswordDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _textEditingController;

  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _formKey.currentState?.reset();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text(context.appLocalizations.createPassword)),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.appLocalizations.createPasswordDescription,
              softWrap: true,
              maxLines: 3,
            ),
            const Gap.vertical(spacing: 10),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: TextFormField(
                controller: _textEditingController,
                enableIMEPersonalizedLearning: false,
                enableSuggestions: false,
                keyboardType: TextInputType.text,
                obscureText: !_isVisible,
                onFieldSubmitted: (value) =>
                    _textEditingController.text = value.trim(),
                onSaved: (newValue) =>
                    _textEditingController.text = newValue ?? '',
                validator: (value) {
                  if (value != null) {
                    if (value.isBlank) {
                      return context.appLocalizations.nonEmptyField(
                        context.appLocalizations.passwordFieldLabel,
                      );
                    }

                    if (value.trim().length < 8) {
                      return context
                          .appLocalizations.passwordFieldMinimum8CharLength;
                    }
                  }

                  return null;
                },
                decoration: InputDecoration(
                  labelText: context.appLocalizations.passwordFieldLabel,
                  border: const OutlineInputBorder(),
                  suffix: IconButton(
                    onPressed: () => setState(() {
                      _isVisible = !_isVisible;
                    }),
                    icon: Icon(
                      _isVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
              ),
            ),
            const Gap.vertical(spacing: 10),
            Text(
              context.appLocalizations.createPasswordAdvice,
              softWrap: true,
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.appLocalizations.cancel),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              return Navigator.pop(
                context,
                removeDiacritics(_textEditingController.text.trim()),
              );
            }
          },
          child: Text(context.appLocalizations.ok),
        ),
      ],
    );
  }
}
