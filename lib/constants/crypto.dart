import 'dart:typed_data';

import 'package:crypto/crypto.dart';

const ivLength = 16;

Uint8List digestPassword(String password) =>
    Uint8List.fromList(sha256.convert(password.codeUnits).bytes);
