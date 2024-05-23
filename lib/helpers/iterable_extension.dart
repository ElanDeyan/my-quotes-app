import 'dart:math';

extension RandomElement<E> on List<E> {
  E get singleSample {
    final randomIndex = Random().nextInt(length);

    return this[randomIndex];
  }

  E? get singleSampleOrNull => isEmpty ? null : singleSample;
}
