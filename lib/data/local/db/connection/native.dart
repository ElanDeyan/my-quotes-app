import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations.dart';
import 'package:flutter/foundation.dart';
import 'package:my_quotes/constants/platforms.dart';
import 'package:my_quotes/repository/secure_repository.dart';
import 'package:my_quotes/services/service_locator.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:sqlite3/open.dart';

Future<({File encryptedDbFile, File unencryptedDbFile})>
    get databaseFile async {
  final appDir = await getApplicationDocumentsDirectory();

  final encryptedDbPath = p.join(appDir.path, 'my_quotes.db.enc');
  final unencryptedDbPath = p.join(appDir.path, 'my_quotes.db');

  return (
    encryptedDbFile: File(encryptedDbPath),
    unencryptedDbFile: File(unencryptedDbPath),
  );
}

DatabaseConnection connect() => DatabaseConnection.delayed(
      Future(
        () async {
          final databaseFiles = await databaseFile;

          if (isAndroidOrIOS) {
            log(
              'Fall off at androidOrIOS database',
              name: 'NativeDatabaseConnection',
            );

            final encryptionPassword = await serviceLocator<SecureRepository>()
                .readDbEncryptionKeyOrCreate();

            log(
              'Password to be used in encryption: $encryptionPassword',
              name: 'NativeDatabase',
            );

            return NativeDatabase.createBackgroundConnection(
              databaseFiles.encryptedDbFile,
              isolateSetup: () async => open
                ..overrideFor(
                  OperatingSystem.android,
                  openCipherOnAndroid,
                )
                ..overrideFor(
                  OperatingSystem.linux,
                  () => DynamicLibrary.open('libsqlcipher.so'),
                )
                ..overrideFor(
                  OperatingSystem.windows,
                  () => DynamicLibrary.open('sqlcipher.dll'),
                ),
              setup: (database) {
                final result = database.select('pragma cipher_version');

                if (result.isEmpty) {
                  throw UnsupportedError(
                    'This database needs to run with SQLCipher, but that library is '
                    'not available!',
                  );
                }

                final escapedKey = encryptionPassword.replaceAll("'", "''");
                database.execute("pragma key = '$escapedKey'");

                // Tests that the key is correct by selecting from a table
                database.execute('select count(*) from sqlite_master');
              },
            );
          }

          log('Using unencrypted db', name: 'NativeDatabaseConnection');
          return NativeDatabase.createBackgroundConnection(
            databaseFiles.unencryptedDbFile,
          );
        },
      ),
    );

Future<void> validateDatabaseSchema(GeneratedDatabase database) async {
  // This method validates that the actual schema of the opened database matches
  // the tables, views, triggers and indices for which drift_dev has generated
  // code.
  // Validating the database's schema after opening it is generally a good idea,
  // since it allows us to get an early warning if we change a table definition
  // without writing a schema migration for it.
  //
  // For details, see: https://drift.simonbinder.eu/docs/advanced-features/migrations/#verifying-a-database-schema-at-runtime
  if (kDebugMode) {
    await VerifySelf(database).validateDatabaseSchema();
  }
}
