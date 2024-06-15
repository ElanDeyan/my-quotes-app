import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:my_quotes/constants/color_pallete.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/repository/user_preferences.dart';
import 'package:my_quotes/routes/routes_config.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: find a better place to run it
  SharedPreferences.setPrefix('myQuotes');

  const userPreferencesHandler = UserPreferences();
  final appPreferences =
      AppPreferences(userPreferencesRepository: userPreferencesHandler);

  await appPreferences.loadLocalPreferences();

  runApp(
    MyAppProvider(
      appPreferencesProvider: appPreferences,
      databaseNotitfier: DatabaseProvider(appRepository: AppDatabase()),
    ),
  );
}

final class MyAppProvider extends StatelessWidget {
  const MyAppProvider({
    super.key,
    required AppPreferences appPreferencesProvider,
    required DatabaseProvider databaseNotitfier,
  })  : _appPreferences = appPreferencesProvider,
        _databaseNotifier = databaseNotitfier;

  final AppPreferences _appPreferences;

  final DatabaseProvider _databaseNotifier;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => _appPreferences),
        ChangeNotifierProvider(create: (_) => _databaseNotifier),
      ],
      child: const MyApp(),
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
