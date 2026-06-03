import 'package:flutter/material.dart';

import '../models/gap_click_config.dart';
import '../services/app_strings.dart';

class GapClickPanel extends StatelessWidget {
  const GapClickPanel({
    required this.config,
    required this.strings,
    required this.onChanged,
    super.key,
  });

  final GapClickConfig config;
  final AppStrings strings;
  final ValueChanged<GapClickConfig> onChanged;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: config.enabled,
      leading: const Icon(Icons.hearing_disabled),
      title: Text(strings.gapClick),
      subtitle: Text(strings.gapClickSummary(config)),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        SwitchListTile(
          value: config.enabled,
          onChanged: (value) => onChanged(config.copyWith(enabled: value)),
          title: Text(strings.enableSilentBarTraining),
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _NumberField(
              label: strings.playBars,
              value: config.playBars,
              enabled: config.enabled,
              onChanged: (value) => onChanged(config.copyWith(playBars: value)),
            ),
            _NumberField(
              label: strings.muteBars,
              value: config.muteBars,
              enabled: config.enabled,
              onChanged: (value) => onChanged(config.copyWith(muteBars: value)),
            ),
          ],
        ),
      ],
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.label,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final String label;
  final int value;
  final bool enabled;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: TextFormField(
        key: ValueKey('$label-$value'),
        initialValue: '$value',
        enabled: enabled,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onChanged: (raw) {
          final parsed = int.tryParse(raw);
          if (parsed != null) {
            onChanged(parsed);
          }
        },
      ),
    );
  }
}
