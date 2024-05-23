import 'package:drift/drift.dart';

@DataClassName('Tag')
class TagTable extends Table {
  IntColumn get id => integer().nullable().autoIncrement()();

  TextColumn get name => text().withLength(min: 1)();
}
