import 'package:basics/basics.dart';
import 'package:flutter/widgets.dart';
import 'package:my_quotes/constants/keys.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/env/env.dart';
import 'package:my_quotes/repository/interfaces/app_repository.dart';
import 'package:my_quotes/repository/interfaces/user_preferences_interfaces.dart';
import 'package:my_quotes/repository/user_preferences.dart';
import 'package:my_quotes/services/service_locator.dart';
import 'package:my_quotes/services/time_ago_setup.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

String getSentryDsn() {
  return switch ((
    const String.fromEnvironment(sentryDsnKey),
    Env.sentryDsn,
  )) {
    (final a, _) when a != '' => a,
    (_, final b) when b.isNotNullOrBlank => b,
    _ => throw UnsupportedError('No sentry dsn defined')
  };
}

Future<void> bootstrapingApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  timeAgoSetup();

  final userPreferences = UserPreferencesWithSharedPreferencesAsync(
    SharedPreferencesAsync(),
  );

  final appPreferences = AppPreferences(
    userPreferencesRepository: userPreferences,
  );

  await appPreferences.loadLocalPreferences();

  serviceLocator.registerLazySingleton<AppRepository>(
    () => AppDatabase(),
  );

  serviceLocator.registerLazySingleton<AppPreferences>(
    () => appPreferences,
  );

  serviceLocator.registerLazySingleton<UserPreferencesRepository>(
    () => userPreferences,
  );
}
