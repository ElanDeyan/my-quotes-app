import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_quotes/repository/user_preferences.dart';
import 'package:my_quotes/routes/routes_config.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // TODO: find a better place to run it
  SharedPreferences.setPrefix('myQuotesPreferences');
  
  const userPreferencesHandler = UserPreferences();
  final appPreferences =
      AppPreferences(userPreferencesRepository: userPreferencesHandler);

  await appPreferences.loadLocalPreferences();

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => _appPreferences),
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
      builder: (context, value, child) => MaterialApp.router(
        routerConfig: routesConfig,
        debugShowCheckedModeBanner: false,
        themeMode: value.themeMode,
        color: value.colorPallete.color,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale(value.language),
        title: 'My Quotes',
      ),
    );
  }
}
