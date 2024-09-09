import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:my_quotes/constants/enums/color_scheme_palette.dart';
import 'package:my_quotes/providers/my_quotes_feedback.dart';
import 'package:my_quotes/routes/routes_config.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:provider/provider.dart';

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
