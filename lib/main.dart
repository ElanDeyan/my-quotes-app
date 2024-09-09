import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_quotes/app.dart';
import 'package:my_quotes/bootstrap.dart';
import 'package:my_quotes/providers/my_app_provider.dart';
import 'package:my_quotes/providers/my_quotes_feedback.dart';
import 'package:my_quotes/services/service_locator.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:sentry/sentry.dart';

void main() async {
  runZonedGuarded(() async {
    final sentryDsn = getSentryDsn();

    await Sentry.init((options) => options.dsn = sentryDsn);

    await bootstrapingApp();

    runApp(
      MyAppProvider(
        appPreferencesProvider: serviceLocator<AppPreferences>(),
        child: const MyQuotesFeedback(
          child: MyApp(),
        ),
      ),
    );
  }, (exception, stackTrace) {
    unawaited(Sentry.captureException(exception, stackTrace: stackTrace));
  });
}
