import 'package:my_quotes/repository/color_scheme_palette_repository.dart';
import 'package:my_quotes/repository/language_repository.dart';
import 'package:my_quotes/repository/theme_mode_repository.dart';

abstract interface class UserPreferencesRepository
    implements
        LanguageRepository,
        ColorSchemePaletteRepository,
        ThemeModeRepository {}
