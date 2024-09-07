import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:my_quotes/constants/crypto.dart';

Uint8List encryptBackupData(Map<String, Object?> userData, String password) {
  final userDataJsonEncoded = jsonEncode(userData);

  final digestedPassword = digestPassword(password);

  final key = Key(digestedPassword);
  final iv = IV.fromLength(ivLength);

  final encrypter = Encrypter(AES(key));

  final encrypted = encrypter.encrypt(userDataJsonEncoded, iv: iv);

  final encryptedDataWithIv = Uint8List.fromList(iv.bytes + encrypted.bytes);
  return encryptedDataWithIv;
}
