import 'package:flutter/material.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(context.appLocalizations.errorOccurred),
      ),
    );
  }
}
