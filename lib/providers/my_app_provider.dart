import 'package:flutter/material.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:provider/provider.dart';

final class MyAppProvider extends StatelessWidget {
  const MyAppProvider({
    required AppPreferences appPreferencesProvider,
    required this.child,
    super.key,
  }) : _appPreferences = appPreferencesProvider;

  final AppPreferences _appPreferences;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _appPreferences,
      child: child,
    );
  }
}
