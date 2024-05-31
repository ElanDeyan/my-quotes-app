import 'package:flutter/material.dart';
import 'package:my_quotes/states/database_provider.dart';
import 'package:provider/provider.dart';

class TagsScreen extends StatelessWidget {
  const TagsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tags'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<DatabaseProvider>(
          builder: (context, database, child) => FutureBuilder(
            future: database.allTags,
            builder: (context, snapshot) {
              return switch (snapshot.connectionState) {
                ConnectionState.none => const Center(
                    child: Text('No database connection'),
                  ),
                ConnectionState.active ||
                ConnectionState.waiting =>
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                ConnectionState.done => snapshot.hasError
                    ? const Center(
                        child: Text('Error'),
                      )
                    : Expanded(
                        child: Wrap(
                          spacing: 5,
                          alignment: WrapAlignment.spaceAround,
                          children: [
                            for (final tag in snapshot.data!)
                              TextButton(
                                onPressed: () {},
                                child: Text(tag.name),
                              ),
                          ],
                        ),
                      ),
              };
            },
          ),
        ),
      ),
    );
  }
}
