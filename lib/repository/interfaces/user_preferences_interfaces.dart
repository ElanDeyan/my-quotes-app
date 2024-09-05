import 'package:my_quotes/repository/interfaces/color_scheme_palette_repository.dart';
import 'package:my_quotes/repository/interfaces/language_repository.dart';
import 'package:my_quotes/repository/interfaces/theme_mode_repository.dart';

abstract interface class UserPreferencesRepository
    implements
        LanguageRepository,
        ColorSchemePaletteRepository,
        ThemeModeRepository {}
