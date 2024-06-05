extension StringExtension on String {
  String toTitleCase() {
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
