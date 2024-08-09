extension IterableExtension<T> on Iterable<T> {
  bool get isMadeOfUniques => toSet().length == length;
}
