import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/constants/destinations.dart';
import 'package:my_quotes/routes/routes_names.dart';

mixin DestinationsMixin {
  static Map<String, DestinationData> destinationsDataOf(
    AppLocalizations appLocalizations,
  ) =>
      <String, DestinationData>{
        homeNavigationKey: (
          index: 0,
          selectedIcon: const Icon(Icons.home),
          outlinedIcon: const Icon(Icons.home_outlined),
          label: appLocalizations.navigationHome,
          debugLabel: 'home',
        ),
        myQuotesNavigationKey: (
          index: 1,
          selectedIcon: const Icon(Icons.format_quote),
          outlinedIcon: const Icon(Icons.format_quote_outlined),
          label: appLocalizations.navgationMyQuotes,
          debugLabel: 'myQuotes'
        ),
        settingsNavigationKey: (
          index: 2,
          selectedIcon: const Icon(Icons.settings),
          outlinedIcon: const Icon(Icons.settings_outlined),
          label: appLocalizations.navigationSettings,
          debugLabel: 'settings'
        ),
      };
}
