import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouterState;

final class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.routerState,
  });

  final GoRouterState routerState;

  @override
  Widget build(BuildContext context) {
    return Text('Page ${routerState.name}');
  }
}
