import 'dart:math' hide log;

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_quotes/constants/tag_name_regexp.dart';

void main() {
  final randomGenerator = RandomGenerator();

  test('Valid values', () {
    for (var i = 0; i < 25; i++) {
      final sample = randomGenerator.fromCharSet(
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-abcdefghijklmnopqrstuvwxyz',
        Random().nextInt(25) + 1,
      );

      expect(tagNameRegExp.hasMatch(sample), isTrue);
    }
  });

  test('Invalid values', () {
    for (var i = 0; i < 25; i++) {
      final sample = randomGenerator.fromCharSet(
        r'!?#$%&*(){}[],./',
        Random().nextInt(25) + 1,
      );

      expect(tagNameRegExp.hasMatch(sample), isFalse);
    }
  });
}
