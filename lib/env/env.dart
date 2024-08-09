import 'package:envied/envied.dart';

part 'env.g.dart';

// TODO: adds obfuscate
@envied
abstract class Env {
  @EnviedField(varName: 'sentryDsn')
  static const String sentryDsn = _Env.sentryDsn;
}
