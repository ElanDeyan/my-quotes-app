import 'package:drift/drift.dart';

Never _unsupported() {
  throw UnsupportedError('No suitable database for this platform');
}

DatabaseConnection connect() {
  _unsupported();
}

Future<void> validateDatabaseSchema(GeneratedDatabase database) async {
  _unsupported();
}
