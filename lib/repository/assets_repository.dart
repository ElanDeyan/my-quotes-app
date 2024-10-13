import 'package:flutter/material.dart';

typedef DataUsage = ({
  String title,
  String introduction,
  DateTime lastUpdated,
  String version,
  Section whatDataIsCollected,
  Section whyDataIsCollected,
  Section howIsDataStored,
  Section whoHasAccessToTheData,
  Section howCanUsersManageTheirData,
  Section changesToPrivacyPolicy,
});

typedef Section = ({String header, String content});

abstract interface class AssetsRepository {
  Future<DataUsage> dataUsageMessageOf(Locale locale);
}
