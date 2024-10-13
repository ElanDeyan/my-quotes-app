import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/constants/enums/color_scheme_palette.dart';
import 'package:my_quotes/screens/feedback/my_quotes_feedback.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:provider/provider.dart';

final class MyQuotesFeedback extends StatelessWidget {
  const MyQuotesFeedback({
    required this.child,
    super.key,
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
