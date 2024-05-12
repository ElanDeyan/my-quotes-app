import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
  });

  static const screenName = 'Settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.goNamed('mainScreen'),
        ),
        title: const Text(screenName),
      ),
      body: const Center(
        child: Text(screenName),
      ),
    );
  }
}
