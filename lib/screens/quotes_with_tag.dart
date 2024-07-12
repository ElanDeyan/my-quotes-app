import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

class QuotesWithTag extends StatelessWidget {
  const QuotesWithTag({super.key, required this.tagId});

  final int tagId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.quotesWithThisTag),
        leading: BackButton(
          onPressed: () => context.canPop()
              ? context.pop()
              : context.goNamed(myQuotesNavigationKey),
        ),
      ),
      body: Consumer<DatabaseProvider>(
        builder: (context, database, child) => FutureBuilder(
          future: database.getQuotesWithTagId(tagId),
          builder: (context, snapshot) {
            final connectionState = snapshot.connectionState;

            switch (connectionState) {
              case ConnectionState.none:
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.noDatabaseConnectionMessage,
                  ),
                );

              case ConnectionState.active || ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );

              case ConnectionState.done:
                if (!snapshot.hasError) {
                  if (snapshot.data!.isEmpty) {
                    return Center(
                      child:
                          Text(AppLocalizations.of(context)!.noQuotesWithTag),
                    );
                  } else {
                    final data = snapshot.data!;
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: const Icon(Icons.format_quote),
                        title: Text(
                          data[index].content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          data[index].author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => context.goNamed(
                          quoteByIdNavigationKey,
                          pathParameters: {'id': '${data[index].id}'},
                        ),
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: Text(AppLocalizations.of(context)!.errorOccurred),
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
