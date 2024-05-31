import 'package:basics/basics.dart';
import 'package:flutter/material.dart';
import 'package:my_quotes/data/local/db/quotes_drift_database.dart';
import 'package:my_quotes/screens/widgets/create_tag_dialog.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await createTagDialog(context)?.then(
            (value) {
              if (value.isNotNullOrBlank) {
                Provider.of<DatabaseProvider>(context, listen: false)
                    .createTag(Tag(name: value!));
              }
            },
          );
        },
        child: const Icon(Icons.new_label),
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
                              ListTile(
                                title: Text(tag.name),
                                trailing: PopupMenuButton<Tag>(
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: tag,
                                      onTap: () async {
                                        final newTagName =
                                            await showUpdateTagDialog(
                                          context,
                                          tag,
                                        );

                                        if (newTagName.isNotNullOrBlank) {
                                          database
                                              .updateTag(
                                                tag.copyWith(name: newTagName),
                                              )
                                              .then(
                                                (value) => ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Successfully updated!',
                                                    ),
                                                  ),
                                                ),
                                              );
                                        }
                                      },
                                      child: const Text('Update'),
                                    ),
                                    PopupMenuItem(
                                      value: tag,
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
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

  Future<String?> showUpdateTagDialog(BuildContext context, Tag tag) {
    final textEditingController =
        TextEditingController.fromValue(TextEditingValue(text: tag.name));
    final updateTagFormKey = GlobalKey<FormState>();
    return showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update tag'),
        content: Form(
          key: updateTagFormKey,
          autovalidateMode: AutovalidateMode.always,
          child: TextFormField(
            controller: textEditingController,
            decoration: const InputDecoration(
              labelText: 'New tag name',
              border: OutlineInputBorder(),
            ),
            validator: (value) => value.isNullOrBlank ? 'Invalid value' : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, textEditingController.text),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
