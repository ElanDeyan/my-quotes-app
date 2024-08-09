import 'package:drift/drift.dart';

@DataClassName('Quote')
class QuoteTable extends Table {
  IntColumn get id => integer().nullable().autoIncrement()();

  TextColumn get content => text().withLength(min: 1)();

  TextColumn get author => text().withLength(min: 1)();

  TextColumn get source => text().nullable()();

  TextColumn get sourceUri => text().nullable()();

  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt =>
      dateTime().nullable().withDefault(currentDateAndTime)();

  TextColumn get tags => text().nullable()();
}
