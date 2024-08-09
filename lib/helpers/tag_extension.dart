import 'package:my_quotes/data/local/db/quotes_drift_database.dart';

extension TagExtension on Tag {
  Map<String, String> get asIdNamePair => {"$id": name};
}
