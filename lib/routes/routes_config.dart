import 'package:go_router/go_router.dart';
import 'package:my_quotes/screens/main/destinations.dart';
import 'package:my_quotes/screens/main/main_app_screen.dart';
import 'package:my_quotes/screens/quote_screen.dart';
import 'package:my_quotes/screens/settings/settings_screen.dart';
import 'package:my_quotes/screens/tags_screen.dart';

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
      path: '/tags',
      name: 'tags',
      builder: (context, state) => const TagsScreen(),
    ),
  ],
);
