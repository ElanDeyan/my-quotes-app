extension MapExtension<K, V> on Map<K, V> {
  Map<K, V> get copy => map(MapEntry.new);
}
