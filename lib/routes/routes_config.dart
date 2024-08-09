import 'package:go_router/go_router.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/screens/add_quote/add_quote_screen.dart';
import 'package:my_quotes/screens/error_screen.dart';
import 'package:my_quotes/screens/main/destinations.dart';
import 'package:my_quotes/screens/main/main_app_screen.dart';
import 'package:my_quotes/screens/quote_screen.dart';
import 'package:my_quotes/screens/quotes_with_tag.dart';
import 'package:my_quotes/screens/search/search_quote_results.dart';
import 'package:my_quotes/screens/settings/settings_screen.dart';
import 'package:my_quotes/screens/tags_screen.dart';
import 'package:my_quotes/screens/update_quote/update_quote_screen.dart';

final routesConfig = GoRouter(
  errorBuilder: (context, state) => const ErrorScreen(),
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: mainScreenNavigationKey,
      builder: (context, state) => MainAppScreen(
        destinations: DestinationsMixin.destinationsDataOf(context),
      ),
      routes: [
        GoRoute(
          path: 'home',
          name: homeNavigationKey,
          builder: (context, state) => MainAppScreen(
            destinations: DestinationsMixin.destinationsDataOf(context),
          ),
        ),
        GoRoute(
          path: 'myQuotes',
          name: myQuotesNavigationKey,
          builder: (context, state) => MainAppScreen(
            destinations: DestinationsMixin.destinationsDataOf(context),
            initialLocationIndex: 1,
          ),
          routes: [
            GoRoute(
              path: 'add',
              name: addQuoteNavigationKey,
              builder: (context, state) => const AddQuoteScreen(),
            ),
            GoRoute(
              path: 'update/:id',
              name: updateQuoteNavigationKey,
              builder: (context, state) => UpdateQuoteScreen(
                quoteId: int.parse(state.pathParameters['id']!),
              ),
            ),
            GoRoute(
              path: 'quote/:id',
              name: quoteByIdNavigationKey,
              builder: (context, state) => QuoteScreen(
                quoteId: int.parse(state.pathParameters['id']!),
              ),
            ),
            GoRoute(
              path: 'tag/:tagId',
              name: quoteWithTagNavigationKey,
              builder: (context, state) => QuotesWithTag(
                tagId: int.parse(state.pathParameters['tagId']!),
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'settings',
          name: settingsNavigationKey,
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: 'tags',
          name: tagsNavigationKey,
          builder: (context, state) => const TagsScreen(),
        ),
        GoRoute(
          path: 'searchResults',
          name: searchResultsNavigationKey,
          builder: (context, state) => SearchQuoteResults(
            searchResults: (state.extra ?? <Quote>[]) as List<Quote>,
          ),
        ),
      ],
    ),
  ],
);
