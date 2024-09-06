import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
// import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

Future<File> get databaseFile async {
  final appDir = await getApplicationDocumentsDirectory();
  // final dbPath = p.join(appDir.path, 'my_quotes.db.enc');
  final dbPath = p.join(appDir.path, 'my_quotes.db');

  return File(dbPath);
}

DatabaseConnection connect() {
  return DatabaseConnection.delayed(
    Future(() async {
      if (Platform.isAndroid) {
        await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();

        final cachebase = (await getTemporaryDirectory()).path;

        sqlite3.tempDirectory = cachebase;
      }

      return NativeDatabase.createBackgroundConnection(
        await databaseFile,
        // isolateSetup: () async => open
        //   ..overrideFor(
        //     OperatingSystem.android,
        //     openCipherOnAndroid,
        //   )
        //   ..overrideFor(
        //     OperatingSystem.linux,
        //     () => DynamicLibrary.open('libsqlcipher.so'),
        //   )
        //   ..overrideFor(
        //     OperatingSystem.windows,
        //     () => DynamicLibrary.open('sqlcipher.dll'),
        //   ),
        // setup: (database) {
        //   final result = database.select('pragma cipher_version');

        //   if (result.isEmpty) {
        //     throw UnsupportedError(
        //       'This database needs to run with SQLCipher, but that library is '
        //       'not available!',
        //     );
        //   }

        //   final escapedKey = _encryptionPassword.replaceAll("'", "''");
        //   database.execute('pragma key = $escapedKey');

        //   // Tests that the key is correct by selecting from a table
        //   database.execute('select count(*) from sqlite_master');
        // },
      );
    }),
  );
}
