import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/repository/app_repository.dart';

final class DatabaseProvider extends ChangeNotifier implements AppRepository {
  DatabaseProvider({
    required AppRepository appRepository,
  }) : _appRepository = appRepository;

  final AppRepository _appRepository;

  @override
  Future<List<Quote>> get allQuotes => _appRepository.allQuotes;

  @override
  Future<int> createQuote(Quote quote) {
    final newId = _appRepository.createQuote(quote);
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
  Stream<List<Quote>> get allQuotesStream => _appRepository.allQuotesStream;

  @override
  Future<int> deleteQuote(int id) {
    final oldId = _appRepository.deleteQuote(id);
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
  Future<int> createTag(String tagName) {
    final newId = _appRepository.createTag(tagName);
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

  @override
  Future<void> clearAllQuotes() async {
    _appRepository.clearAllQuotes();
    notifyListeners();
  }

  @override
  Future<void> clearAllTags() async {
    _appRepository.clearAllTags();
    notifyListeners();
  }

  @override
  Future<void> restoreQuotes(List<Quote> quotes) async {
    _appRepository.restoreQuotes(quotes);
    notifyListeners();
  }

  @override
  Future<void> restoreTags(List<Tag> tags) async {
    _appRepository.restoreTags(tags);
    notifyListeners();
  }

  @override
  Future<void> restoreData(List<Tag> tags, List<Quote> quotes) async {
    _appRepository.restoreData(tags, quotes);
    notifyListeners();
  }

  @override
  Stream<List<Tag>> get allTagsStream => _appRepository.allTagsStream;
}
