import 'package:basics/basics.dart';
import 'package:my_quotes/constants/keys.dart';
import 'package:my_quotes/env/env.dart';

String getSentryDsn() {
  return switch ((
    const String.fromEnvironment(sentryDsnKey),
    Env.sentryDsn,
  )) {
    (final a, _) when a != '' => a,
    (_, final b) when b.isNotNullOrBlank => b,
    _ => throw UnsupportedError('No sentry dsn defined')
  };
}
