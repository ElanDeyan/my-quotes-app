import 'package:flutter/material.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/helpers/connection_state_extension.dart';
import 'package:my_quotes/repository/assets_repository.dart';
import 'package:my_quotes/screens/data_usage/data_usage_form.dart';
import 'package:my_quotes/services/service_locator.dart';

class DataUsagePage extends StatefulWidget {
  const DataUsagePage({
    super.key,
  });

  @override
  State<DataUsagePage> createState() => _DataUsagePageState();
}

class _DataUsagePageState extends State<DataUsagePage> {
  late final Future<DataUsage> _dataUsage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dataUsage = serviceLocator<AssetsRepository>()
        .dataUsageMessageOf(Locale(context.appLocalizations.localeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data usage'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: _dataUsage,
        builder: (context, snapshot) {
          if (snapshot.connectionState.isDone && snapshot.hasData) {
            return DataUsageForm(dataUsageInfo: snapshot.data!);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
