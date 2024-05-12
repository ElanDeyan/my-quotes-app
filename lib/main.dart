import 'package:flutter/material.dart';
import 'package:my_quotes/routes/routes_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyAppProvider());
}

final class MyAppProvider extends StatelessWidget {
  const MyAppProvider({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: add provider dependencies
    return const MyApp();
  }
}

final class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: define theme and appearance
    return MaterialApp.router(
      routerConfig: routesConfig,
      debugShowCheckedModeBanner: false,
      title: 'My Quotes',
    );
  }
}
