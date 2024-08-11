import 'package:my_quotes/data/local/db/quotes_drift_database.dart'
    show Quote, Tag;
import 'package:my_quotes/repository/app_repository.dart' show AppRepository;

class DatabaseLocator implements AppRepository {
  DatabaseLocator(this._appRepository);

  final AppRepository _appRepository;

  @override
  Future<List<Quote>> get allQuotes => _appRepository.allQuotes;

  @override
  Stream<List<Quote>> get allQuotesStream => _appRepository.allQuotesStream;
  
  @override
  Future<List<Tag>> get allTags => _appRepository.allTags;

  @override
  Future<void> clearAllQuotes() => _appRepository.clearAllQuotes();

  @override
  Future<void> clearAllTags() => _appRepository.clearAllTags();

  @override
  Future<int> createQuote(Quote quote) => _appRepository.createQuote(quote);

  @override
  Future<int> createTag(String tagName) => _appRepository.createTag(tagName);

  @override
  Future<int> deleteQuote(int id) => _appRepository.deleteQuote(id);

  @override
  Future<int> deleteTag(int id) => _appRepository.deleteTag(id);

  @override
  Stream<List<Quote>> get favorites => _appRepository.favorites;

  @override
  Future<Quote?> getQuoteById(int id) => _appRepository.getQuoteById(id);

  @override
  Future<List<Quote>> getQuotesWithTagId(int tagId) =>
      _appRepository.getQuotesWithTagId(tagId);

  @override
  Future<Tag?> getTagById(int id) => _appRepository.getTagById(id);

  @override
  Future<List<Tag>> getTagsByIds(Iterable<int> ids) =>
      _appRepository.getTagsByIds(ids);

  @override
  Future<Quote?> get randomQuote => _appRepository.randomQuote;


  @override
  Future<void> restoreData(List<Tag> tags, List<Quote> quotes) =>
      _appRepository.restoreData(tags, quotes);

  @override
  Future<void> restoreQuotes(List<Quote> quotes) =>
      _appRepository.restoreQuotes(quotes);

  @override
  Future<void> restoreTags(List<Tag> tags) => _appRepository.restoreTags(tags);

  @override
  Future<bool> updateQuote(Quote quote) => _appRepository.updateQuote(quote);

  @override
  Future<bool> updateTag(Tag tag) => _appRepository.updateTag(tag);

  @override
  Stream<List<Tag>> get allTagsStream => _appRepository.allTagsStream;
}
