import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_quotes/repository/assets_repository.dart';
import 'package:my_quotes/repository/secure_repository.dart';
import 'package:my_quotes/routes/routes_names.dart';
import 'package:my_quotes/screens/data_usage/data_usage_box.dart';
import 'package:my_quotes/screens/data_usage/data_usage_content.dart';
import 'package:my_quotes/services/service_locator.dart';

class DataUsageForm extends StatefulWidget {
  const DataUsageForm({
    required this.dataUsageInfo,
    super.key,
  });

  final DataUsage dataUsageInfo;

  @override
  State<DataUsageForm> createState() => _DataUsageFormState();
}

class _DataUsageFormState extends State<DataUsageForm> {
  var _acceptedDataUsage = false;
  late final WidgetStatesController _buttonStatesController;

  @override
  void initState() {
    super.initState();
    _buttonStatesController = WidgetStatesController({WidgetState.disabled});
  }

  @override
  void dispose() {
    _buttonStatesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => didPop = false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: DataUsageBox(
              child: DataUsageContent(dataUsageInfo: widget.dataUsageInfo),
            ),
          ),
          const Spacer(),
          CheckboxListTile(
            value: _acceptedDataUsage,
            onChanged: (newValue) => setState(() {
              final accepted = newValue ?? false;
              if (accepted) {
                _buttonStatesController.update(WidgetState.disabled, false);
              } else {
                _buttonStatesController.update(WidgetState.disabled, true);
              }
              _acceptedDataUsage = accepted;
            }),
            title: const Text('I agree with how this app use my data'),
            subtitle: const Text(
              'If you disagree, feel free to uninstall the app.',
            ),
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: !_acceptedDataUsage ? null : _onAcceptedDataUsage,
            statesController: _buttonStatesController,
            child: const Text('Ok'),
          ),
          const Spacer(
            flex: 3,
          ),
        ],
      ),
    );
  }

  void _onAcceptedDataUsage() => serviceLocator<SecureRepository>()
      .toggleAcceptedAppDataUsage(value: _acceptedDataUsage)
      .then(
        (_) => mounted ? context.pushReplacementNamed(homeNavigationKey) : null,
      );
}
