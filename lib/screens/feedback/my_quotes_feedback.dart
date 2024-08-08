import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';

final class MyQuotesFeedbackFormArea extends StatefulWidget {
  const MyQuotesFeedbackFormArea(
    this.context, {
    super.key,
    required this.scrollController,
    required this.fn,
  });

  final BuildContext context;
  final ScrollController? scrollController;
  final Future<void> Function(String, {Map<String, Object?>? extras}) fn;

  @override
  State<MyQuotesFeedbackFormArea> createState() =>
      _MyQuotesFeedbackFormAreaState();
}

class _MyQuotesFeedbackFormAreaState extends State<MyQuotesFeedbackFormArea> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _feedbackTextController;

  @override
  void initState() {
    super.initState();
    _feedbackTextController = TextEditingController();
  }

  @override
  void dispose() {
    _feedbackTextController.dispose();
    _formKey.currentState?.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.appLocalizations.provideFeedback,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              context.appLocalizations.feedbackInstructions,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  TextFormField(
                    controller: _feedbackTextController,
                    smartDashesType: SmartDashesType.enabled,
                    smartQuotesType: SmartQuotesType.enabled,
                    decoration: InputDecoration(
                      labelText: context.appLocalizations.feedbackTextLabel,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) => value.isNullOrBlank
                        ? context.appLocalizations.requiredFieldAlert
                        : null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        widget.fn(_feedbackTextController.text);
                      }
                    },
                    label:
                        Text(AppLocalizations.of(widget.context)!.feedbackSend),
                    icon: const Icon(Icons.send_outlined),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
