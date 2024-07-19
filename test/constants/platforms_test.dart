import 'package:flutter/foundation.dart'
    show TargetPlatform, debugDefaultTargetPlatformOverride;
import 'package:flutter_test/flutter_test.dart'
    show expect, isFalse, isTrue, tearDown, test;
import 'package:my_quotes/constants/platforms.dart';

void main() {
  tearDown(() => debugDefaultTargetPlatformOverride = null);
  test('is android', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    expect(isAndroid, isTrue);
    expect(isAndroidOrIOS, isTrue);
    expect(isIOS, isFalse);
    expect(isDesktop, isFalse);
    expect(isLinux, isFalse);
    expect(isWindows, isFalse);
    expect(isMacOS, isFalse);

    debugDefaultTargetPlatformOverride = null;
  });

  test('is iOS', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    expect(isAndroid, isFalse);
    expect(isAndroidOrIOS, isTrue);
    expect(isIOS, isTrue);
    expect(isDesktop, isFalse);
    expect(isLinux, isFalse);
    expect(isWindows, isFalse);
    expect(isMacOS, isFalse);

    debugDefaultTargetPlatformOverride = null;
  });

  test('is desktop', () {
    for (final platform in [
      TargetPlatform.linux,
      TargetPlatform.macOS,
      TargetPlatform.windows,
    ]) {
      debugDefaultTargetPlatformOverride = platform;

      expect(isAndroid, isFalse);
      expect(isAndroidOrIOS, isFalse);
      expect(isIOS, isFalse);
      expect(isDesktop, isTrue);
    }

    debugDefaultTargetPlatformOverride = null;
  });

  test('is Windows', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;

    expect(isAndroid, isFalse);
    expect(isAndroidOrIOS, isFalse);
    expect(isIOS, isFalse);
    expect(isDesktop, isTrue);
    expect(isLinux, isFalse);
    expect(isWindows, isTrue);
    expect(isMacOS, isFalse);

    debugDefaultTargetPlatformOverride = null;
  });

  test('is macOS', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

    expect(isAndroid, isFalse);
    expect(isAndroidOrIOS, isFalse);
    expect(isIOS, isFalse);
    expect(isDesktop, isTrue);
    expect(isLinux, isFalse);
    expect(isWindows, isFalse);
    expect(isMacOS, isTrue);

    debugDefaultTargetPlatformOverride = null;
  });

  test('is linux', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;

    expect(isAndroid, isFalse);
    expect(isAndroidOrIOS, isFalse);
    expect(isIOS, isFalse);
    expect(isDesktop, isTrue);
    expect(isLinux, isTrue);
    expect(isWindows, isFalse);
    expect(isMacOS, isFalse);

    debugDefaultTargetPlatformOverride = null;
  });
}
