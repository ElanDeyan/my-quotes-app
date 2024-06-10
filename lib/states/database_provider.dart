import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/repository/app_repository.dart';
import 'package:my_quotes/repository/quotes_repository.dart';
import 'package:my_quotes/repository/tags_repository.dart';

final class DatabaseProvider extends ChangeNotifier
    implements QuotesRepository, TagsRepository {
  DatabaseProvider({
    required AppRepository appRepository,
  }) : _appRepository = appRepository;

  final AppRepository _appRepository;

  @override
  Future<List<Quote>> get allQuotes => _appRepository.allQuotes;

  @override
  Future<int> addQuote(Quote quote) {
    final newId = _appRepository.addQuote(quote);
    notifyListeners();
    return newId;
  }

  @override
  Stream<List<Quote>> get favorites => _appRepository.favorites;

  @override
  Future<Quote?> getQuoteById(int id) => _appRepository.getQuoteById(id);

  @override
  Future<Quote?> get randomQuote => _appRepository.randomQuote;

  @override
  Future<int> removeQuote(int id) {
    final oldId = _appRepository.removeQuote(id);
    notifyListeners();
    return oldId;
  }

  @override
  Future<bool> updateQuote(Quote quote) {
    final didUpdate = _appRepository.updateQuote(quote);
    notifyListeners();
    return didUpdate;
  }

  @override
  Future<List<Tag>> get allTags => _appRepository.allTags;

  @override
  Future<int> createTag(Tag tag) {
    final newId = _appRepository.createTag(tag);
    notifyListeners();
    return newId;
  }

  @override
  Future<Tag?> getTagById(int id) => _appRepository.getTagById(id);

  @override
  Future<List<Tag>> getTagsByIds(Iterable<int> ids) =>
      _appRepository.getTagsByIds(ids);

  @override
  Future<int> deleteTag(int id) {
    final oldId = _appRepository.deleteTag(id);
    notifyListeners();
    return oldId;
  }

  @override
  Future<bool> updateTag(Tag tag) {
    final didUpdate = _appRepository.updateTag(tag);
    notifyListeners();
    return didUpdate;
  }

  @override
  Future<List<Quote>> getQuotesWithTagId(int tagId) {
    return _appRepository.getQuotesWithTagId(tagId);
  }
}
