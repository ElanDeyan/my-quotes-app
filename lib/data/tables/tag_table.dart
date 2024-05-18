import 'package:drift/drift.dart';
import 'package:my_quotes/data/tables/quote_table.dart';

@DataClassName('Tag')
class TagTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get tagName => text().withLength(min: 1)();

  IntColumn get quotes => integer().nullable().references(QuoteTable, #id)();
}
