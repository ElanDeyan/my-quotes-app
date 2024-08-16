import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/screens/my_quotes/_quotes_sliver_list_view_bottom_spacing.dart';
import 'package:my_quotes/screens/my_quotes/quotes_list_view_filtering.dart';
import 'package:my_quotes/screens/my_quotes/quotes_list_view_sorting.dart';
import 'package:my_quotes/screens/my_quotes/quotes_sliver_list_view.dart';
import 'package:my_quotes/shared/widgets/gap.dart';
import 'package:my_quotes/shared/widgets/icon_with_label.dart';

class QuotesListViewContainer extends StatefulWidget {
  const QuotesListViewContainer({
    super.key,
    required this.quotes,
  });

  final List<Quote> quotes;

  @override
  State<QuotesListViewContainer> createState() =>
      _QuotesListViewContainerState();
}

class _QuotesListViewContainerState extends State<QuotesListViewContainer> {
  QuotesListViewSorting _viewSorting = QuotesListViewSorting.createdAtDesc;
  QuotesListViewFiltering _viewFiltering = QuotesListViewFiltering.none;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      clipBehavior: Clip.none,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(
          child: Gap.vertical(spacing: 5),
        ),
        SliverToBoxAdapter(
          child: Align(
            alignment: Alignment.topCenter,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                PopupMenuButton<QuotesListViewSorting>(
                  initialValue: _viewSorting,
                  onSelected: (value) => setState(() {
                    _viewSorting = value;
                  }),
                  tooltip: context
                      .appLocalizations.quotesListViewSortingButtonTooltip,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: IconWithLabel(
                      icon: const Icon(Icons.sort_outlined),
                      horizontalGap: 5,
                      label: Text(
                        context.appLocalizations.quotesListViewSortingButton,
                      ),
                    ),
                  ),
                  itemBuilder: (context) => List.generate(
                    QuotesListViewSorting.values.length,
                    (index) {
                      final actual = QuotesListViewSorting.values[index];
                      final child = _viewSorting == actual
                          ? IconWithLabel(
                              icon: const Icon(Icons.check_outlined),
                              horizontalGap: 5,
                              label: Text(
                                actual.localizedName(context.appLocalizations),
                              ),
                            )
                          : Text(
                              actual.localizedName(context.appLocalizations),
                            );

                      return PopupMenuItem(
                        value: actual,
                        child: child,
                      );
                    },
                    growable: false,
                  ),
                ),
                FilterChip(
                  label: Text(
                    context.appLocalizations.quotesListViewFilteringFavorites,
                  ),
                  selected: _viewFiltering == QuotesListViewFiltering.favorites,
                  onSelected: (selected) => setState(() {
                    if (selected) {
                      _viewFiltering = QuotesListViewFiltering.favorites;
                    } else {
                      _viewFiltering = QuotesListViewFiltering.none;
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Gap.vertical(spacing: 5),
        ),
        QuotesSliverListView(
          quotes: _viewFiltering.filter(
            _viewSorting.sort(
              widget.quotes,
            ),
          ),
        ),
        const QuotesSliverListViewBottomSpacing(),
      ],
    );
  }
}
