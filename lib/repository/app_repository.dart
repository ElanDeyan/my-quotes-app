import 'package:my_quotes/repository/quotes_repository.dart';
import 'package:my_quotes/repository/tags_repository.dart';

abstract interface class AppRepository
    implements QuotesRepository, TagsRepository {}
