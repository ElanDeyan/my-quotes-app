import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:my_quotes/constants/crypto.dart';

String decryptBackupData(String password, Uint8List backupFileData) {
  final iv = IV(backupFileData.sublist(0, ivLength));

  final encryptedData = backupFileData.sublist(ivLength);

  final digestedPassword =
      Uint8List.fromList(sha256.convert(password.codeUnits).bytes);

  final key = Key(digestedPassword);

  final encrypter = Encrypter(AES(key));

  final encrypted = Encrypted(encryptedData);

  return encrypter.decrypt(encrypted, iv: iv);
}
