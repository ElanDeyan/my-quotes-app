import 'package:my_quotes/data/local/db/quotes_drift_database.dart';

abstract interface class TagsRepository {
  Future<List<Tag>> get allTags;

  Future<Tag?> getTagById(int id);

  Future<List<Tag>> getTagsByIds(Iterable<int> ids);

  Future<int> createTag(Tag tag);

  Future<bool> updateTag(Tag tag);

  Future<int> deleteTag(int id);
}
