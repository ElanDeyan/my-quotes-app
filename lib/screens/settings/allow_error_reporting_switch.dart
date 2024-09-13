import 'package:flutter/material.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:my_quotes/repository/secure_repository.dart';
import 'package:my_quotes/services/service_locator.dart';
import 'package:my_quotes/shared/actions/show_toast.dart';
import 'package:my_quotes/shared/widgets/pill_chip.dart';

class AllowErrorReportingSwitch extends StatefulWidget {
  const AllowErrorReportingSwitch({
    super.key,
    required this.data,
  });

  final bool data;

  @override
  State<AllowErrorReportingSwitch> createState() =>
      _AllowErrorReportingSwitchState();
}

class _AllowErrorReportingSwitchState extends State<AllowErrorReportingSwitch> {
  late bool _allowErrorReporting;

  @override
  void initState() {
    super.initState();
    _allowErrorReporting = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.report_outlined),
      title: Text(context.appLocalizations.allowErrorReporting),
      subtitle: Text(
        context.appLocalizations.allowErrorReportingDescription,
        maxLines: 2,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Switch(
        value: _allowErrorReporting,
        onChanged: (newValue) async {
          try {
            setState(() {
              _allowErrorReporting = newValue;
            });
          } finally {
            serviceLocator<SecureRepository>()
                .toggleAllowErrorReporting(newValue)
                .then(
                  (_) => context.mounted
                      ? showToast(
                          context,
                          child: PillChip(
                            label: Text(
                              context.appLocalizations.savedPreference,
                            ),
                          ),
                        )
                      : null,
                );
          }
        },
      ),
    );
  }
}
