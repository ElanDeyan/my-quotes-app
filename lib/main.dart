import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_quotes/app.dart';
import 'package:my_quotes/bootstrap.dart';
import 'package:my_quotes/providers/my_app_provider.dart';
import 'package:my_quotes/providers/my_quotes_feedback.dart';
import 'package:my_quotes/services/service_locator.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:sentry/sentry.dart';

void main() => runZonedGuarded(() async {
      final sentryDsn = getSentryDsn();

      await Sentry.init((options) => options.dsn = sentryDsn);

      WidgetsFlutterBinding.ensureInitialized();

      await bootstrapServices();

      runApp(
        MyAppProvider(
          appPreferencesProvider: serviceLocator<AppPreferences>(),
          child: const MyQuotesFeedback(
            child: MyApp(),
          ),
        ),
      );
    }, (error, stackTrace) {
      unawaited(Sentry.captureException(error, stackTrace: stackTrace));
      log(error.toString(), name: 'Error');
    });
