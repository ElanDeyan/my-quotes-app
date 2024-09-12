abstract interface class SecureRepository {
  static const dbEncryptionKey = 'my_quotes_db_encryption_key';

  String generateRandomSecurePassword(int length);

  Future<void> createAndStoreDbEncryptionKey();

  Future<void> createAndStoreDbEncryptionKeyIfMissing();

  Future<String> readDbEncryptionKeyOrCreate();

  Future<bool> get hasDbEncryptionKey;
}
