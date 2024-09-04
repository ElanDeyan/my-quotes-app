extension ListExtensionForTesting<T> on List<T> {
  List<T> get toShuffledView => sublist(0)..shuffle();
}
