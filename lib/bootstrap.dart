import 'package:basics/basics.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_quotes/constants/keys.dart';
import 'package:my_quotes/constants/platforms.dart';
import 'package:my_quotes/data/local/assets/assets.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/data/local/secure_repository/secure_repository_impl.dart';
import 'package:my_quotes/data/local/user_preferences/user_preferences_with_shared_preferences_async.dart';
import 'package:my_quotes/env/env.dart';
import 'package:my_quotes/repository/app_repository.dart';
import 'package:my_quotes/repository/assets_repository.dart';
import 'package:my_quotes/repository/secure_repository.dart';
import 'package:my_quotes/repository/user_preferences_repository.dart';
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

Future<void> bootstrapServices() async {
  timeAgoSetup();

  serviceLocator.registerLazySingleton<SecureRepository>(
    () => SecureRepositoryImpl(const FlutterSecureStorage()),
  );

  if (!isWeb) {
    await serviceLocator<SecureRepository>()
        .createAndStoreDbEncryptionKeyIfMissing();
  }

  serviceLocator
    ..registerLazySingleton<AssetsRepository>(
      () => Assets(rootBundle),
    )
    ..registerLazySingleton<UserPreferencesRepository>(
      () => UserPreferencesWithSharedPreferencesAsync(
        SharedPreferencesAsync(),
      ),
    )
    ..registerLazySingleton<AppPreferences>(
      () => AppPreferences(
        userPreferencesRepository: serviceLocator<UserPreferencesRepository>(),
      ),
    );

  await serviceLocator<AppPreferences>().loadLocalPreferences();

  serviceLocator.registerLazySingleton<AppRepository>(
    AppDatabase.new,
  );
}
