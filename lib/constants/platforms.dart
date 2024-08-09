import 'package:flutter/foundation.dart';

const isWeb = kIsWeb;
final isIOS = !isWeb && defaultTargetPlatform == TargetPlatform.iOS;
final isAndroid = !isWeb && defaultTargetPlatform == TargetPlatform.android;
final isAndroidOrIOS = isAndroid || isIOS;
final isLinux = !isWeb && defaultTargetPlatform == TargetPlatform.linux;
final isWindows = !isWeb && defaultTargetPlatform == TargetPlatform.windows;
final isMacOS = !isWeb && defaultTargetPlatform == TargetPlatform.macOS;
final isDesktop = isLinux || isWindows || isMacOS;
