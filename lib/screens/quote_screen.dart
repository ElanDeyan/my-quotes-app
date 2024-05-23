import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

final class QuoteScreen extends StatelessWidget {
  const QuoteScreen({
    super.key,
    required this.quoteId,
  });

  final int quoteId;

  static const screenName = 'Quote';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => context.goNamed('mainScreen'),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Center(
        child: Consumer<DatabaseProvider>(
          builder: (context, database, child) => FutureBuilder(
            future: database.getQuoteById(quoteId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final data = snapshot.data!;
                return Column(
                  children: [
                    const Text('Quote data'),
                    Text(data.toString()),
                    ElevatedButton(
                      onPressed: () => context.goNamed(
                        'update',
                        pathParameters: {'id': '$quoteId'},
                      ),
                      child: const Text('Update'),
                    ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
