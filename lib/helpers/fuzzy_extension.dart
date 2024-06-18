import 'package:fuzzywuzzy/algorithms/weighted_ratio.dart';
import 'package:fuzzywuzzy/applicable.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:fuzzywuzzy/model/extracted_result.dart';

extension FuzzySearch<T extends Object> on List<T> {
  List<ExtractedResult<T>> fuzzyExtractAllSorted({
    required String query,
    String Function(T)? getter,
    int cutoff = 0,
    Applicable ratio = const WeightedRatio(),
  }) {
    return extractAllSorted(
      query: query,
      choices: this,
      cutoff: cutoff,
      getter: getter,
      ratio: ratio,
    );
  }
}
