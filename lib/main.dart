import 'dart:async';

import 'package:basics/basics.dart';
import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:my_quotes/constants/enums/color_scheme_palette.dart';
import 'package:my_quotes/constants/keys.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/env/env.dart';
import 'package:my_quotes/repository/interfaces/app_repository.dart';
import 'package:my_quotes/repository/user_preferences.dart';
import 'package:my_quotes/routes/routes_config.dart';
import 'package:my_quotes/screens/feedback/my_quotes_feedback.dart';
import 'package:my_quotes/services/service_locator.dart';
import 'package:my_quotes/services/time_ago_setup.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:provider/provider.dart';
import 'package:sentry/sentry.dart';

void main() async {
  runZonedGuarded(() async {
    final sentryDsn = switch ((
      const String.fromEnvironment(sentryDsnKey),
      Env.sentryDsn,
    )) {
      (final a, _) when a != '' => a,
      (_, final b) when b.isNotNullOrBlank => b,
      _ => throw UnsupportedError('No sentry dsn defined')
    };

    await Sentry.init((options) => options.dsn = sentryDsn);
    await initApp();
  }, (exception, stackTrace) {
    unawaited(Sentry.captureException(exception, stackTrace: stackTrace));
  });
}

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  timeAgoSetup();

  final appPreferences = AppPreferences(
    userPreferencesRepository: const UserPreferences(),
  );

  await appPreferences.loadLocalPreferences();

  serviceLocator.registerLazySingleton<AppRepository>(
    () => AppDatabase(),
  );

  runApp(
    MyAppProvider(
      appPreferencesProvider: appPreferences,
    ),
  );
}

final class MyAppProvider extends StatelessWidget {
  const MyAppProvider({
    super.key,
    required AppPreferences appPreferencesProvider,
  }) : _appPreferences = appPreferencesProvider;

  final AppPreferences _appPreferences;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _appPreferences,
      child: const MyQuotesFeedback(child: MyApp()),
    );
  }
}

final class MyQuotesFeedback extends StatelessWidget {
  const MyQuotesFeedback({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppPreferences>(
      builder: (context, appPreferences, _) => BetterFeedback(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        pixelRatio: MediaQuery.devicePixelRatioOf(context),
        mode: FeedbackMode.navigate,
        feedbackBuilder: (context, fn, scrollController) =>
            MyQuotesFeedbackFormArea(
          context,
          scrollController: scrollController,
          fn: fn,
        ),
        themeMode: appPreferences.themeMode,
        theme: FeedbackThemeData(
          colorScheme: ColorSchemePalette.lightColorScheme(
            appPreferences.colorSchemePalette,
          ),
        ),
        child: child,
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

        return MyQuotesFeedback(
          child: MaterialApp.router(
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
          ),
        );
      },
    );
  }
}
