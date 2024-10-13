import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/repository/assets_repository.dart';
import 'package:my_quotes/repository/language_repository.dart';
import 'package:yaml/yaml.dart';

final class Assets implements AssetsRepository {
  const Assets(this.assetBundle);

  final AssetBundle assetBundle;

  @override
  Future<DataUsage> dataUsageMessageOf(Locale locale) async {
    late final Locale chosenLocale;
    if (!AppLocalizations.supportedLocales.contains(locale)) {
      chosenLocale = LanguageRepository.defaultLanguage;
    } else {
      chosenLocale = locale;
    }

    final filePath =
        'assets/data_usage_message/data_usage_${chosenLocale.languageCode}.yaml';

    final dataUsageMap = loadYaml(await _loadYamlFile(filePath)) as YamlMap;

    return _parseDataUsageFile(
      _yamlMapToDartMapStringObject(dataUsageMap),
    );
  }

  Future<String> _loadYamlFile(String path) => assetBundle.loadString(path);

  Map<String, Object?> _yamlMapToDartMapStringObject(YamlMap yamlMap) {
    return yamlMap.map((key, value) {
      final Object? mapValue = switch (value) {
        final YamlMap yamlMap => _yamlMapToDartMapStringObject(yamlMap),
        final YamlList yamlList => yamlList.toList(),
        _ => value,
      };

      return MapEntry(key.toString(), mapValue);
    });
  }

  DataUsage _parseDataUsageFile(Map<String, Object?> map) {
    log(map.toString());
    if (map
        case {
          'title': final String title,
          'last_updated': final String lastUpdated,
          'version': final String version,
          'introduction': final String introduction,
          'what': final Map<String, Object?> whatDataIsCollected,
          'why': final Map<String, Object?> whyDataIsCollected,
          'how': final Map<String, Object?> howIsDataStored,
          'who': final Map<String, Object?> whoHasAccessToData,
          'manage': final Map<String, Object?> managingData,
          'changes': final Map<String, Object?> changesInPolicy,
        } when DateTime.tryParse(lastUpdated) != null) {
      return (
        title: title,
        version: version,
        lastUpdated: DateTime.parse(lastUpdated),
        introduction: introduction,
        whatDataIsCollected: _parseDataUsageSection(whatDataIsCollected),
        whyDataIsCollected: _parseDataUsageSection(whyDataIsCollected),
        howIsDataStored: _parseDataUsageSection(howIsDataStored),
        whoHasAccessToTheData: _parseDataUsageSection(whoHasAccessToData),
        howCanUsersManageTheirData: _parseDataUsageSection(managingData),
        changesToPrivacyPolicy: _parseDataUsageSection(changesInPolicy),
      );
    }
    throw const FormatException('Invalid data usage file format');
  }

  Section _parseDataUsageSection(Map<String, Object?> map) {
    if (map
        case {'header': final String header, 'content': final String content}) {
      return (header: header, content: content);
    }
    throw const FormatException('Invalid section format');
  }
}
