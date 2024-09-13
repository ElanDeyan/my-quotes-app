import 'package:flutter/material.dart';
import 'package:my_quotes/constants/enums/color_scheme_palette.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/repository/color_scheme_palette_repository.dart';
import 'package:my_quotes/shared/widgets/icon_with_label.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:provider/provider.dart';

class ChooseColorSchemePaletteDialog extends StatelessWidget {
  const ChooseColorSchemePaletteDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appPreferences = Provider.of<AppPreferences>(context, listen: false);

    return SimpleDialog(
      clipBehavior: Clip.none,
      title: Text(context.appLocalizations.chooseColorPaletteMessage),
      children: List.generate(
        ColorSchemePaletteRepository.values.length,
        (index) {
          final colorSchemePalette = ColorSchemePaletteRepository.values[index];

          return SimpleDialogOption(
            onPressed: () =>
                appPreferences.colorSchemePalette = colorSchemePalette,
            child: IconWithLabel(
              icon: CircleAvatar(
                minRadius: 5.0,
                backgroundColor: ColorSchemePalette.primaryColor(
                  colorSchemePalette,
                  MediaQuery.platformBrightnessOf(context),
                ),
              ),
              horizontalGap: 5.0,
              label: Text(
                key: Key(
                  'color_palette_${colorSchemePalette.storageName}',
                ),
                softWrap: true,
                context.appLocalizations.colorPaletteName(
                  colorSchemePalette.storageName,
                ),
              ),
            ),
          );
        },
        growable: false,
      ),
    );
  }
}
