import 'package:drift/drift.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/data/tables/tag_table.dart';

part 'tags_dao.g.dart';

@DriftAccessor(tables: [TagTable])
class TagsDao extends DatabaseAccessor<AppDatabase> with _$TagsDaoMixin {
  TagsDao(super.attachedDatabase);

  Future<List<Tag>> get allTags async => select(tagTable).get();

  Future<Tag?> getTagById(int id) {
    return (select(tagTable)..where((row) => row.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<Tag>> getTagsByIds(Iterable<int> ids) {
    return (select(tagTable)..where((row) => row.id.isIn(ids))).get();
  }
}
