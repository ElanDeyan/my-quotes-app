import 'package:basics/string_basics.dart';
import 'package:flutter/material.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';

final class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.textEditingController,
  });

  final TextEditingController textEditingController;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

final class _PasswordFieldState extends State<PasswordField> {
  bool _isVisible = false;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    widget.textEditingController.text = _textEditingController.text;
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _textEditingController,
      enableIMEPersonalizedLearning: false,
      enableSuggestions: false,
      keyboardType: TextInputType.text,
      obscureText: !_isVisible,
      onFieldSubmitted: (value) => _textEditingController.text = value.trim(),
      onSaved: (newValue) => _textEditingController.text = newValue ?? '',
      validator: (value) {
        if (value != null) {
          if (value.isBlank) {
            return context.appLocalizations.nonEmptyField('Password');
          }

          if (value.trim().length < 8) {
            return context.appLocalizations.passwordFieldMinimum8CharLength;
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
    );
  }
}
