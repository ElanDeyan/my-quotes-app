import 'package:flutter/material.dart';
import 'package:my_quotes/routes/routes_config.dart';

void main() {
  runApp(const MainApp());
}

final class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: routesConfig,
      builder: (context, child) => Scaffold(
        appBar: AppBar(),
        body: child,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
