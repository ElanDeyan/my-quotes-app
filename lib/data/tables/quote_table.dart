import 'package:drift/drift.dart';
import 'package:my_quotes/data/tables/tag_table.dart';

@DataClassName('Quote')
class QuoteTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get content => text().withLength(min: 1)();

  TextColumn get author => text().withLength(min: 1)();

  TextColumn get source => text().nullable()();

  TextColumn get sourceUri => text().nullable()();

  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();

  IntColumn get tags => integer().nullable().references(TagTable, #id)();
}
