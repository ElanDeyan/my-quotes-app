abstract interface class SecureRepository {
  static const dbEncryptionKey = 'my_quotes_db_encryption_key';

  static const allowErrorReportingKey = 'allow_error_reporting';

  Future<bool> get allowErrorReporting;

  Future<bool> get hasAllowErrorReportingKey;

  Future<void> toggleAllowErrorReporting([bool? value]);

  String generateRandomSecurePassword(int length);

  Future<void> createAndStoreDbEncryptionKey();

  Future<void> createAndStoreDbEncryptionKeyIfMissing();

  Future<String> readDbEncryptionKeyOrCreate();

  Future<bool> get hasDbEncryptionKey;
}
