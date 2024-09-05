import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/repository/interfaces/quotes_repository.dart';
import 'package:my_quotes/repository/interfaces/tags_repository.dart';

abstract interface class AppRepository
    implements QuotesRepository, TagsRepository {
  Future<void> restoreData(List<Tag> tags, List<Quote> quotes);
}
