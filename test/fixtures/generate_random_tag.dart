import 'dart:math';

import 'package:faker/faker.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';

Tag generateRandomTag({bool generateId = false}) => Tag(
      id: generateId ? Random().nextInt(50) : null,
      name: faker.lorem.word().toLowerCase(),
    );
