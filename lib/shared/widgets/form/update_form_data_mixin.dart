import 'package:basics/basics.dart';
import 'package:my_quotes/constants/id_separator.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';

mixin UpdateFormDataMixin {
  Map<String, Object?> updateFormData(
    Map<String, Object?> formData,
    Set<Tag> tags,
  ) {
    formData
      ..putIfAbsent(
        'tags',
        () => _getTagsValue(tags),
      )
      ..update(
        'source',
        (value) => (value as String?).isNullOrBlank ? '' : value!.trim(),
        ifAbsent: () => '',
      )
      ..update(
        'sourceUri',
        (value) => (value as String?).isNullOrBlank ? '' : value!.trim(),
        ifAbsent: () => '',
      );

    return formData;
  }

  String? _getTagsValue(Set<Tag> tags) {
    if (tags.isEmpty) return null;

    return tags.map((tag) => tag.id).nonNulls.join(idSeparatorChar);
  }
}
