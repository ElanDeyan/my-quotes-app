import 'dart:async';

import 'package:my_quotes/repository/app_repository.dart';
import 'package:my_quotes/repository/secure_repository.dart';
import 'package:my_quotes/services/encrypt_backup_data.dart';
import 'package:my_quotes/services/retrieve_user_data.dart';
import 'package:my_quotes/states/app_preferences.dart';
import 'package:share_plus/share_plus.dart';

Future<XFile> generateBackupFile(
  AppRepository appRepository,
  AppPreferences appPreferences,
  SecureRepository secureRepository,
  String password,
) async {
  final userData = await retrieveUserData(
    appPreferences,
    appRepository,
    secureRepository,
  );

  return XFile.fromData(encryptBackupData(userData, password));
}
