import 'package:flutter/material.dart';
import 'package:my_quotes/constants/enums/color_scheme_palette.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/screens/settings/choose_color_scheme_palette_dialog.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:provider/provider.dart';

class ChooseColorSchemePaletteTile extends StatelessWidget {
  const ChooseColorSchemePaletteTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<AppPreferences, ColorSchemePalette>(
      selector: (_, appPreferences) => appPreferences.colorSchemePalette,
      child: const Icon(Icons.palette_outlined),
      builder: (context, colorSchemePalette, child) => ListTile(
        leading: child,
        title: Text(context.appLocalizations.colorPallete),
        subtitle: Row(
          children: [
            CircleAvatar(
              backgroundColor: ColorSchemePalette.primaryColor(
                colorSchemePalette,
                MediaQuery.platformBrightnessOf(context),
              ),
              minRadius: 5,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              context.appLocalizations.colorPaletteName(
                colorSchemePalette.storageName,
              ),
            ),
          ],
        ),
        onTap: () => showDialog<void>(
          context: context,
          builder: (_) => const ChooseColorSchemePaletteDialog(
            key: Key('choose_color_scheme_palette_dialog'),
          ),
        ),
      ),
    );
  }
}
