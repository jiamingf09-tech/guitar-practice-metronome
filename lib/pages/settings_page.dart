import 'package:flutter/material.dart';

import '../services/app_locale_controller.dart';
import '../services/app_strings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({required this.localeController, super.key});

  final AppLocaleController localeController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: localeController,
      builder: (context, _) {
        final strings = AppStrings(localeController.language);
        final theme = Theme.of(context);

        return Scaffold(
          appBar: AppBar(title: Text(strings.settings)),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(strings.language),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SegmentedButton<AppLanguage>(
                    segments: [
                      ButtonSegment(
                        value: AppLanguage.english,
                        label: Text(strings.english),
                      ),
                      ButtonSegment(
                        value: AppLanguage.chinese,
                        label: Text(strings.chinese),
                      ),
                    ],
                    selected: {localeController.language},
                    showSelectedIcon: false,
                    onSelectionChanged: (selection) {
                      localeController.setLanguage(selection.first);
                    },
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                tileColor: theme.colorScheme.surfaceContainer,
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.graphic_eq),
                title: Text(strings.audioEngine),
                subtitle: Text(strings.audioEngineDescription),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                tileColor: theme.colorScheme.surfaceContainer,
              ),
            ],
          ),
        );
      },
    );
  }
}
