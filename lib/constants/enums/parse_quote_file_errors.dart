import 'package:flutter/material.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';

enum ParseQuoteFileErrors {
  notJsonFormat(0, 'invalid_json_format'),
  notJsonMap(1, 'invalid_json_map'),
  notCaseFieldsAndTypes(2, 'not_cased_fields'),
  noChosenFile(3, 'no_chosen_file');

  const ParseQuoteFileErrors(this.errorCode, this.errorCodeString);

  final int errorCode;
  final String errorCodeString;

  static String localizedErrorMessageOf(
    BuildContext context,
    ParseQuoteFileErrors error,
  ) =>
      switch (error) {
        ParseQuoteFileErrors.noChosenFile =>
          context.appLocalizations.parseQuoteFileErrorMessageNoChosenFile,
        ParseQuoteFileErrors.notJsonFormat =>
          context.appLocalizations.parseQuoteFileErrorMessageNotJsonFormat,
        ParseQuoteFileErrors.notJsonMap =>
          context.appLocalizations.parseQuoteFileErrorMessageNotJsonMap,
        ParseQuoteFileErrors.notCaseFieldsAndTypes =>
          context.appLocalizations.parseQuoteFileErrorMessageNotCaseFields,
      };
}
