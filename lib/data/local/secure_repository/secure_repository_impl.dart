import 'dart:async';
import 'dart:developer';
import 'dart:math' show Random;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_quotes/repository/secure_repository.dart';

final class SecureRepositoryImpl implements SecureRepository {
  SecureRepositoryImpl(this.secureStorage) {
    scheduleMicrotask(() async {
      if (!(await hasAllowErrorReportingKey)) {
        await secureStorage.write(
          key: SecureRepository.allowErrorReportingKey,
          value: false.toString(),
        );
      }
    });

    scheduleMicrotask(() async {
      if (!(await hasAcceptedAppDataUsageKey)) {
        await secureStorage.write(
          key: SecureRepository.acceptedAppDataUsageKey,
          value: false.toString(),
        );
      }
    });
  }

  final FlutterSecureStorage secureStorage;

  @override
  Future<void> createAndStoreDbEncryptionKey() async {
    final password = generateRandomSecurePassword(16);
    log('Created password: $password', name: 'SecureRepositoryImpl');
    await secureStorage.write(
      key: SecureRepository.dbEncryptionKey,
      value: password,
    );
  }

  @override
  Future<void> createAndStoreDbEncryptionKeyIfMissing() async {
    if (!(await hasDbEncryptionKey)) {
      await createAndStoreDbEncryptionKey();
    }
  }

  @override
  Future<bool> get hasDbEncryptionKey =>
      secureStorage.read(key: SecureRepository.dbEncryptionKey).then((value) {
        log(
          'Has db encryption key? ${value != null}',
          name: 'SecureRepositoryImpl',
        );
        return value != null;
      });

  /// Based on implementation of the
  /// [random_password_generator](https://pub.dev/packages/random_password_generator)
  /// package
  @override
  String generateRandomSecurePassword(int length) {
    const lowerCaseLetters = 'abcdefghijklmnopqrstuvwxyz';
    final upperCaseLetters = lowerCaseLetters.toUpperCase();
    const numbers = '0123456789';
    const specialChars = r'!@#$%&*(){}[]\|?/+=_-';

    final requiredChars = [
      lowerCaseLetters[Random.secure().nextInt(lowerCaseLetters.length)],
      upperCaseLetters[Random.secure().nextInt(upperCaseLetters.length)],
      numbers[Random.secure().nextInt(numbers.length)],
      specialChars[Random.secure().nextInt(specialChars.length)],
    ].join();

    final allowedChars =
        lowerCaseLetters + upperCaseLetters + numbers + specialChars;

    final passwordChars = String.fromCharCodes(
      List.generate(
        length - requiredChars.length,
        (_) => allowedChars
            .codeUnitAt(Random.secure().nextInt(allowedChars.length)),
      ),
    );

    final allChars = (requiredChars + passwordChars).split('')
      ..shuffle(Random.secure());

    return allChars.join();
  }

  @override
  Future<String> readDbEncryptionKeyOrCreate() async {
    final dbEncryptionPassword =
        await secureStorage.read(key: SecureRepository.dbEncryptionKey);

    if (dbEncryptionPassword == null) {
      await createAndStoreDbEncryptionKey();
      return readDbEncryptionKeyOrCreate();
    }

    log(
      'Db encryption password: $dbEncryptionPassword',
      name: 'SecureRepositoryImpl',
    );

    return dbEncryptionPassword;
  }

  @override
  Future<bool> get hasAllowErrorReportingKey => secureStorage
      .read(key: SecureRepository.allowErrorReportingKey)
      .then((value) => value != null);

  @override
  Future<bool> get allowErrorReporting async => bool.parse(
        await secureStorage.read(
              key: SecureRepository.allowErrorReportingKey,
            ) ??
            false.toString(),
      );

  @override
  Future<void> toggleAllowErrorReporting({bool? value}) async {
    if (value != null) {
      await secureStorage.write(
        key: SecureRepository.allowErrorReportingKey,
        value: value.toString(),
      );
      return;
    }
    if (await allowErrorReporting) {
      await secureStorage.write(
        key: SecureRepository.allowErrorReportingKey,
        value: false.toString(),
      );
    } else {
      await secureStorage.write(
        key: SecureRepository.allowErrorReportingKey,
        value: true.toString(),
      );
    }
  }

  @override
  Future<bool> get acceptedAppDataUsage => secureStorage
          .read(key: SecureRepository.acceptedAppDataUsageKey)
          .then((value) {
        log('Accepted app data usage? $value', name: 'SecureRepository');
        return bool.parse(value ?? false.toString());
      });

  @override
  Future<bool> get hasAcceptedAppDataUsageKey => secureStorage
          .read(key: SecureRepository.acceptedAppDataUsageKey)
          .then((value) {
        log('Accepted app data usage? $value', name: 'SecureRepository');
        return value != null;
      });

  @override
  Future<void> toggleAcceptedAppDataUsage({bool? value}) async {
    late final bool valueToAssign;

    if (value == null) {
      final storedValue = await secureStorage.read(
        key: SecureRepository.acceptedAppDataUsageKey,
      );
      valueToAssign = !(bool.tryParse(storedValue.toString()) ?? false);
    } else {
      valueToAssign = value;
    }

    await secureStorage.write(
      key: SecureRepository.acceptedAppDataUsageKey,
      value: valueToAssign.toString(),
    );
  }
}
