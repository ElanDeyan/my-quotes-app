import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/nullable_extension.dart';

extension QuoteExtension on Quote {
  bool get hasSourceAndUri => source.isNotNull && sourceUri.isNotNull;

  bool get hasSource => source is String && source != '';

  bool get hasSourceUri => sourceUri.isNotNull;

  Iterable<int> get tagsId =>
      tags?.split(',').map(int.tryParse).nonNulls ?? const <int>[];
}
