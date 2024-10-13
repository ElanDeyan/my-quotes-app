import 'dart:developer' as developer;

import 'package:flutter/material.dart';

final class MyQuotesRouteObserver extends NavigatorObserver {
  void _log(
    String message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      developer.log(
        message,
        name: name ?? 'RouteObserver',
        error: error,
        stackTrace: stackTrace,
        time: DateTime.now(),
      );

  @override
  // ignore: strict_raw_type
  void didPop(Route route, Route? previousRoute) => _log(
        'Pop | From ${route.settings.name} to ${previousRoute?.settings.name}',
      );

  @override
  // ignore: strict_raw_type
  void didPush(Route route, Route? previousRoute) => _log(
        'Push | From ${previousRoute?.settings.name} to ${route.settings.name}',
      );

  @override
  // ignore: strict_raw_type
  void didRemove(Route route, Route? previousRoute) => _log(
        'Remove | From ${route.settings.name} '
        'to ${previousRoute?.settings.name}',
      );

  @override
  // ignore: strict_raw_type
  void didReplace({Route? newRoute, Route? oldRoute}) => _log(
        'Replace | Old ${oldRoute?.settings.name} '
        '-> New ${newRoute?.settings.name}',
      );
}
