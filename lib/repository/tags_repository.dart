import 'package:my_quotes/data/local/db/quotes_drift_database.dart';

abstract interface class TagsRepository {
  Future<List<Tag>> get allTags;

  Stream<List<Tag>> get allTagsStream;

  Future<Tag?> getTagById(int id);

  Future<List<Tag>> getTagsByIds(Iterable<int> ids);

  Future<int> createTag(String tagName);

  Future<bool> updateTag(Tag tag);

  Future<int> deleteTag(int id);

  Future<void> restoreTags(List<Tag> tags);

  Future<void> clearAllTags();
}
