import 'package:flutter/material.dart';
import 'package:my_quotes/repository/assets_repository.dart';
import 'package:my_quotes/screens/data_usage/data_usage_last_updated_date_time.dart';
import 'package:my_quotes/screens/data_usage/data_usage_section_header.dart';
import 'package:my_quotes/screens/data_usage/data_usage_version.dart';
import 'package:my_quotes/shared/widgets/gap.dart';

class DataUsageContent extends StatelessWidget {
  const DataUsageContent({
    required this.dataUsageInfo,
    super.key,
  });

  final DataUsage dataUsageInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey(dataUsageInfo),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DataUsageSectionHeader(title: dataUsageInfo.title),
        DataUsageLastUpdatedDateTime(
          lastUpdatedDateTime: dataUsageInfo.lastUpdated,
        ),
        DataUsageVersion(version: dataUsageInfo.version),
        const Gap.vertical(spacing: 5),
        Text(dataUsageInfo.introduction),
        const Gap.vertical(spacing: 5),
        DataUsageSectionHeader(
          title: dataUsageInfo.whatDataIsCollected.header,
        ),
        Text(dataUsageInfo.whatDataIsCollected.content),
        const Gap.vertical(spacing: 5),
        DataUsageSectionHeader(
          title: dataUsageInfo.whyDataIsCollected.header,
        ),
        Text(dataUsageInfo.whyDataIsCollected.content),
        const Gap.vertical(spacing: 5),
        DataUsageSectionHeader(title: dataUsageInfo.howIsDataStored.header),
        Text(dataUsageInfo.howIsDataStored.content),
        const Gap.vertical(spacing: 5),
        DataUsageSectionHeader(
          title: dataUsageInfo.whoHasAccessToTheData.header,
        ),
        Text(dataUsageInfo.whoHasAccessToTheData.content),
        const Gap.vertical(spacing: 5),
        DataUsageSectionHeader(
          title: dataUsageInfo.howCanUsersManageTheirData.header,
        ),
        Text(dataUsageInfo.howCanUsersManageTheirData.content),
        const Gap.vertical(spacing: 5),
        DataUsageSectionHeader(
          title: dataUsageInfo.changesToPrivacyPolicy.header,
        ),
        Text(dataUsageInfo.changesToPrivacyPolicy.content),
      ],
    );
  }
}
