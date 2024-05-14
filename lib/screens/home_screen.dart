import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  static const screenName = 'Home';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(AppLocalizations.of(context)!.helloWorld),
    );
  }
}
