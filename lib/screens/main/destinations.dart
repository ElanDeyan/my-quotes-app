import 'package:flutter/material.dart';
import 'package:my_quotes/constants/destinations.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/routes/routes_names.dart';

mixin DestinationsMixin {
  static Map<String, DestinationData> destinationsDataOf(
    BuildContext context,
  ) =>
      <String, DestinationData>{
        homeNavigationKey: (
          index: 0,
          selectedIcon: const Icon(Icons.home),
          outlinedIcon: const Icon(Icons.home_outlined),
          label: context.appLocalizations.navigationHome,
          debugLabel: 'home',
        ),
        myQuotesNavigationKey: (
          index: 1,
          selectedIcon: const Icon(Icons.format_quote),
          outlinedIcon: const Icon(Icons.format_quote_outlined),
          label: context.appLocalizations.navgationMyQuotes,
          debugLabel: 'myQuotes'
        ),
        settingsNavigationKey: (
          index: 2,
          selectedIcon: const Icon(Icons.settings),
          outlinedIcon: const Icon(Icons.settings_outlined),
          label: context.appLocalizations.navigationSettings,
          debugLabel: 'settings'
        ),
      };
}
