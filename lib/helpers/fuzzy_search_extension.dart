import 'package:fuzzywuzzy/algorithms/weighted_ratio.dart';
import 'package:fuzzywuzzy/applicable.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:fuzzywuzzy/model/extracted_result.dart';

extension FuzzySearchExtension<T extends Object> on List<T> {
  List<ExtractedResult<T>> fuzzyExtractAllSorted({
    int cutoff = 0,
    String Function(T)? getter,
    required String query,
    Applicable ratio = const WeightedRatio(),
  }) {
    return extractAllSorted(
      query: query,
      choices: this,
      cutoff: cutoff,
      ratio: ratio,
      getter: getter,
    );
  }
}
