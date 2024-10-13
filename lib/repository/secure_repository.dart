abstract interface class SecureRepository {
  static const dbEncryptionKey = 'my_quotes_db_encryption_key';

  static const allowErrorReportingKey = 'allow_error_reporting';

  static const acceptedAppDataUsageKey = 'accepted_app_data_usage';

  Future<bool> get allowErrorReporting;

  Future<bool> get acceptedAppDataUsage;

  Future<bool> get hasAllowErrorReportingKey;

  Future<bool> get hasAcceptedAppDataUsageKey;

  Future<void> toggleAllowErrorReporting({bool? value});

  Future<void> toggleAcceptedAppDataUsage({bool? value});

  String generateRandomSecurePassword(int length);

  Future<void> createAndStoreDbEncryptionKey();

  Future<void> createAndStoreDbEncryptionKeyIfMissing();

  Future<String> readDbEncryptionKeyOrCreate();

  Future<bool> get hasDbEncryptionKey;
}
