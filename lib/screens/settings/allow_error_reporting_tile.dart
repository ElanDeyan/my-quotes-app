import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:my_quotes/repository/secure_repository.dart';
import 'package:my_quotes/screens/my_quotes/_no_database_connection_message.dart';
import 'package:my_quotes/screens/settings/allow_error_reporting_switch.dart';
import 'package:my_quotes/services/service_locator.dart';
import 'package:my_quotes/shared/widgets/an_error_occurred_message.dart';

final class AllowErrorReportingTile extends StatelessWidget {
  const AllowErrorReportingTile({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: serviceLocator<SecureRepository>().allowErrorReporting,
      builder: (context, snapshot) {
        final connectionState = snapshot.connectionState;
        final hasError = snapshot.hasError;
        final hasData = snapshot.hasData;

        final data = snapshot.data;

        if (hasError) {
          log(
            snapshot.error.toString(),
            name: 'SettingsScreen-ErrorReportingSwitch',
          );
        }

        return switch ((connectionState, hasError, hasData)) {
          (ConnectionState.none, _, _) => const NoDatabaseConnectionMessage(),
          (ConnectionState.waiting, _, _) => const Center(
              child: CircularProgressIndicator(),
            ),
          (ConnectionState.active || ConnectionState.done, _, true)
              when data != null =>
            AllowErrorReportingSwitch(data: data),
          _ => const AnErrorOccurredMessage(),
        };
      },
    );
  }
}
