import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:my_quotes/constants/enums/parse_quote_file_errors.dart';
import 'package:my_quotes/services/get_backup_file.dart';
import 'package:my_quotes/services/parse_quote_file.dart';

Future<QuoteFileParsingResult> handleQuoteFile() async {
  final quoteFile = await getBackupFile();

  if (quoteFile != null) {
    return compute(parseQuoteFile, quoteFile);
  }
  return (data: null, error: ParseQuoteFileErrors.noChosenFile);
}
