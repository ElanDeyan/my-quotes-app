import 'package:flutter/material.dart';
import 'package:my_quotes/constants/destinations.dart';

mixin DestinationsMixin {
  static const destinationsData = <String, DestinationData>{
    homeNavigationKey: (
      index: 0,
      selectedIcon: Icon(Icons.home),
      outlinedIcon: Icon(Icons.home_outlined),
      label: 'Home',
      debugLabel: 'home',
    ),
    myQuotesNavigationKey: (
      index: 1,
      selectedIcon: Icon(Icons.format_quote),
      outlinedIcon: Icon(Icons.format_quote_outlined),
      label: 'My quotes',
      debugLabel: 'myQuotes'
    ),
    settingsNavigationKey: (
      index: 2,
      selectedIcon: Icon(Icons.settings),
      outlinedIcon: Icon(Icons.settings_outlined),
      label: 'Settings',
      debugLabel: 'settings'
    ),
  };
}
