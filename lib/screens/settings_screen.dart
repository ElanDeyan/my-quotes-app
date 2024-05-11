import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouterState;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.routerState,
  });

  final GoRouterState routerState;

  @override
  Widget build(BuildContext context) {
    return Text('Page ${routerState.name}');
  }
}
