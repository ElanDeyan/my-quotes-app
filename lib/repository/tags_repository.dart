import 'package:my_quotes/data/local/db/quotes_drift_database.dart';

abstract interface class TagsRepository {
  Future<List<Tag>> get allTags;

  Future<Tag?> getTagById(int id);

  Future<int> createTag(Tag tag);

  Future<bool> updateTag(Tag tag);

  Future<int> removeTag(int id);
}
