extension NullableExtension<T extends Object> on T? {
  bool get isNull => this == null;

  bool get isNotNull => this != null;
}
