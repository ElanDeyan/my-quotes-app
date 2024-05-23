import 'package:go_router/go_router.dart';
import 'package:my_quotes/screens/add_quote_screen.dart';
import 'package:my_quotes/screens/main/destinations.dart';
import 'package:my_quotes/screens/main/main_app_screen.dart';
import 'package:my_quotes/screens/quote_screen.dart';
import 'package:my_quotes/screens/settings/settings_screen.dart';
import 'package:my_quotes/screens/update_quote_screen.dart';

final routesConfig = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'mainScreen',
      builder: (context, state) => const MainAppScreen(
        destinations: DestinationsMixin.destinationsData,
      ),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/quotes/:id',
      name: 'quote',
      builder: (context, state) => QuoteScreen(
        quoteId: int.parse(state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: '/add',
      name: 'add',
      builder: (context, state) => const AddQuoteScreen(),
    ),
    GoRoute(
      path: '/update/:id',
      name: 'update',
      builder: (context, state) => UpdateQuoteScreen(
        quoteId: int.parse(state.pathParameters['id']!),
      ),
    ),
  ],
);
