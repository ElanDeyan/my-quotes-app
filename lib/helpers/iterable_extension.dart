extension RandomElement<E> on List<E> {
  Iterable<E> get uniques => toSet();
}
