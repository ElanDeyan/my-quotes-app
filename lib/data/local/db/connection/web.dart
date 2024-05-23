import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/material.dart';

DatabaseConnection connect() {
  return DatabaseConnection.delayed(
    Future(() async {
      final db = await WasmDatabase.open(
        databaseName: 'my-quotes-app',
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        driftWorkerUri: Uri.parse('drift_worker.js'),
      );

      if (db.missingFeatures.isNotEmpty) {
        debugPrint('Using ${db.chosenImplementation} due to unsupported '
            'browser features: ${db.missingFeatures}');
      }
      return db.resolvedExecutor;
    }),
  );
}

Future<void> validateDatabaseSchema(GeneratedDatabase database) async {}
