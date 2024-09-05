import 'package:envied/envied.dart';

part 'env.g.dart';

// ignore: avoid_classes_with_only_static_members
@envied
abstract class Env {
  @EnviedField(varName: 'sentryDsn', obfuscate: true)
  static final String sentryDsn = _Env.sentryDsn;
}
