import 'package:flutter/foundation.dart';

const isWeb = kIsWeb;
final isIOS = !isWeb && defaultTargetPlatform == TargetPlatform.iOS;
final isAndroid = !isWeb && defaultTargetPlatform == TargetPlatform.android;
final isAndroidOrIOS = isAndroid || isIOS;
final isLinux = !isWeb && defaultTargetPlatform == TargetPlatform.linux;
final isDesktop = !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows);
