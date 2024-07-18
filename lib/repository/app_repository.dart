import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/repository/quotes_repository.dart';
import 'package:my_quotes/repository/tags_repository.dart';

abstract interface class AppRepository
    implements QuotesRepository, TagsRepository {
  Future<void> restoreData(List<Tag> tags, List<Quote> quotes);
}
