import 'package:go_router/go_router.dart';
import 'package:my_quotes/screens/all_quotes_screen.dart';
import 'package:my_quotes/screens/home_screen.dart';
import 'package:my_quotes/screens/quote_screen.dart';
import 'package:my_quotes/screens/settings_screen.dart';

final routesConfig = GoRouter(
  initialLocation: '/',
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      name: 'Home',
      builder: (context, state) => HomeScreen(
        routerState: state,
      ),
    ),
    GoRoute(
      path: '/settings',
      name: 'Settings',
      builder: (context, state) => SettingsScreen(
        routerState: state,
      ),
    ),
    GoRoute(
      path: '/quotes',
      name: 'Quotes',
      builder: (context, state) => AllQuotesScreen(
        routerState: state,
      ),
      routes: <GoRoute>[
        GoRoute(
          path: ':id',
          name: 'Quote',
          builder: (context, state) => QuoteScreen(
            routerState: state,
          ),
        ),
      ],
    ),
  ],
);
