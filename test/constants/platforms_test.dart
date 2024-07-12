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

    debugDefaultTargetPlatformOverride = null;
  });

  test('is iOS', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    expect(isAndroid, isFalse);
    expect(isAndroidOrIOS, isTrue);
    expect(isIOS, isTrue);
    expect(isDesktop, isFalse);

    debugDefaultTargetPlatformOverride = null;
  });

  test('is desktop', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    expect(isAndroid, isFalse);
    expect(isAndroidOrIOS, isTrue);
    expect(isIOS, isTrue);
    expect(isDesktop, isFalse);

    debugDefaultTargetPlatformOverride = null;
  });
}
