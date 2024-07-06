import 'dart:async';

import 'package:basics/basics.dart';
import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:my_quotes/constants/color_pallete.dart';
import 'package:my_quotes/constants/keys.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/repository/user_preferences.dart';
import 'package:my_quotes/routes/routes_config.dart';
import 'package:my_quotes/services/setup.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';
import 'package:sentry/sentry.dart';

void main() async {
  runZonedGuarded(
    () async {
      await dotenv.load();

      final sentryDsn = switch ((
        const String.fromEnvironment(sentryDsnKey),
        dotenv.env[sentryDsnKey]
      )) {
        (final a, _) when a != '' => a,
        (_, final b) when b.isNotNullOrBlank => b,
        _ => throw UnsupportedError('No sentry key defined')
      };

      await Sentry.init((options) => options.dsn = sentryDsn);
      await initApp();
    },
    (exception, stackTrace) async =>
        await Sentry.captureException(exception, stackTrace: stackTrace),
  );
}

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  servicesSetup();

  final appPreferences = AppPreferences(
    userPreferencesRepository: const UserPreferences(),
  );

  await appPreferences.loadLocalPreferences();

  runApp(
    MyAppProvider(
      appPreferencesProvider: appPreferences,
      databaseNotifier: DatabaseProvider(appRepository: AppDatabase()),
    ),
  );
}

final class MyAppProvider extends StatelessWidget {
  const MyAppProvider({
    super.key,
    required AppPreferences appPreferencesProvider,
    required DatabaseProvider databaseNotifier,
  })  : _appPreferences = appPreferencesProvider,
        _databaseNotifier = databaseNotifier;

  final AppPreferences _appPreferences;

  final DatabaseProvider _databaseNotifier;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => _appPreferences),
        ChangeNotifierProvider(create: (_) => _databaseNotifier),
      ],
      child: BetterFeedback(
        mode: FeedbackMode.navigate,
        pixelRatio: MediaQuery.devicePixelRatioOf(context),
        child: const MyApp(),
      ),
    );
  }
}

final class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppPreferences>(
      builder: (context, appPreferences, child) {
        final language = appPreferences.language.split('_');
        late final String scriptCode;
        late final String? countryCode;

        if (language.length != 1) {
          scriptCode = language.first;
          countryCode = language.last;
        } else {
          scriptCode = language.single;
          countryCode = null;
        }

        return MaterialApp.router(
          routerConfig: routesConfig,
          debugShowCheckedModeBanner: false,
          themeMode: appPreferences.themeMode,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorSchemePalette.lightColorScheme(
              appPreferences.colorSchemePalette,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorSchemePalette.darkColorScheme(
              appPreferences.colorSchemePalette,
            ),
          ),
          localizationsDelegates: const [
            ...AppLocalizations.localizationsDelegates,
            ...GlobalMaterialLocalizations.delegates,
            ...FormBuilderLocalizations.localizationsDelegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale(scriptCode, countryCode),
          title: 'My Quotes',
        );
      },
    );
  }
}
