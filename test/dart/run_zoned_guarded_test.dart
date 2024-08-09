import 'dart:async' show runZonedGuarded;

import 'package:flutter_test/flutter_test.dart';

Never alwaysThrows() => throw Exception();

int one() => 1;

void main() {
  test('Thowing operation returns null', () {
    final operationResult = runZonedGuarded(
      () {
        return alwaysThrows();
      },
      (error, stack) {},
    );

    expect(operationResult, isNull);
  });

  test('Throwing inside onError throws', () {
    expect(
      () => runZonedGuarded(
        () {
          return alwaysThrows();
        },
        (error, stack) => throw error,
      ),
      throwsException,
    );
  });

  test('Returns value when not has error', () {
    final operationResult = runZonedGuarded(
      () {
        return one();
      },
      (error, stack) {},
    );

    expect(operationResult, isNotNull);
    expect(operationResult, equals(1));
  });
}
