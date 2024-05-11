import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRouterState;

final class QuoteScreen extends StatelessWidget {
  const QuoteScreen({
    super.key,
    required this.routerState,
  });

  final GoRouterState routerState;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Page ${routerState.name} with ${routerState.pathParameters} parameters',
    );
  }
}
