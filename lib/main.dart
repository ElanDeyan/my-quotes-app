import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/routes/routes_config.dart';
import 'package:my_quotes/screens/all_quotes_screen.dart';
import 'package:my_quotes/screens/home_screen.dart';

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

final class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedIndex = 0;

  void _updateIndex(int value) => setState(() {
        _selectedIndex = value;
      });

  Widget get bodyContent => switch (_selectedIndex) {
        0 => const HomeScreen(),
        1 => const AllQuotesScreen(),
        _ => throw UnimplementedError(),
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My quotes'),
        actions: <IconButton>[
          IconButton(
            onPressed: () => context.goNamed('settings'),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          bodyContent,
          ElevatedButton(
            onPressed: () => context.goNamed(
              'quote',
              pathParameters: <String, String>{'id': '1'},
            ),
            child: const Text('Go to quote 1'),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            selectedIcon: Icon(Icons.home),
          ),
          NavigationDestination(
            icon: Icon(Icons.format_quote_outlined),
            label: 'All quotes',
            selectedIcon: Icon(Icons.format_quote),
          ),
        ],
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _updateIndex,
      ),
    );
  }
}
