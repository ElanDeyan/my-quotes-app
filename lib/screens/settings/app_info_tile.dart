import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_quotes/helpers/build_context_extension.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInfoTile extends StatelessWidget {
  const AppInfoTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline),
      title: Text(context.appLocalizations.info),
      onTap: () => showAboutDialog(
        context: context,
        applicationName: 'My Quotes',
        applicationVersion: '0.1.0',
        applicationIcon: const Icon(Icons.format_quote),
        children: [
          Text(context.appLocalizations.infoDescription),
          Wrap(
            spacing: 5.0,
            children: <IconButton>[
              IconButton(
                onPressed: () async => await launchUrl(
                  Uri.parse(
                    'https://www.linkedin.com/in/elan-almeida-a3391225b/',
                  ),
                ),
                icon: const FaIcon(FontAwesomeIcons.linkedinIn),
              ),
              IconButton(
                onPressed: () async => await launchUrl(
                  Uri.parse('https://github.com/ElanDeyan'),
                ),
                icon: const FaIcon(FontAwesomeIcons.github),
              ),
              IconButton(
                onPressed: () async => await launchUrl(
                  Uri.parse(
                    'https://youtube.com/@deyanwithcode?si=HB1KS0Ys3fqQBkAk',
                  ),
                ),
                icon: const FaIcon(FontAwesomeIcons.youtube),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
