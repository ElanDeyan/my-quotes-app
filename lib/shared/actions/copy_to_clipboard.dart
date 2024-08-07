import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_quotes/shared/actions/show_toast.dart';
import 'package:my_quotes/shared/widgets/pill_chip.dart';

Future<void> copyToClipBoard(BuildContext context, String text) async {
  await Clipboard.setData(ClipboardData(text: text)).then(
    (value) => context.mounted
        ? showToast(
            context,
            child: PillChip(
              label: Text(AppLocalizations.of(context)!.copiedToClipboard),
            ),
          )
        : null,
  );
}
