import 'dart:math';

import 'package:faker/faker.dart';
import 'package:my_quotes/constants/id_separator.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';

Quote generateRandomQuote({
  bool generateId = false,
  bool generateTags = false,
}) {
  const maxId = 100;
  return Quote(
    id: generateId ? Random().nextInt(maxId) : null,
    content: faker.lorem.sentence(),
    author: faker.person.name(),
    createdAt: faker.date.dateTime().copyWith(millisecond: 0, microsecond: 0),
    isFavorite: Random().nextBool(),
    source: faker.conference.name(),
    sourceUri: faker.internet.httpsUrl(),
    tags: generateTags
        ? RandomGenerator()
            .amount((_) => Random().nextInt(maxId), 5)
            .join(idSeparatorChar)
        : null,
  );
}
