import 'package:flutter/material.dart';

import '../models/speed_trainer_config.dart';
import '../services/app_strings.dart';

class SpeedTrainerPanel extends StatelessWidget {
  const SpeedTrainerPanel({
    required this.config,
    required this.strings,
    required this.onChanged,
    super.key,
  });

  final SpeedTrainerConfig config;
  final AppStrings strings;
  final ValueChanged<SpeedTrainerConfig> onChanged;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: config.enabled,
      leading: const Icon(Icons.trending_up),
      title: Text(strings.speedTrainer),
      subtitle: Text(strings.speedTrainerSummary(config)),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        SwitchListTile(
          value: config.enabled,
          onChanged: (value) => onChanged(config.copyWith(enabled: value)),
          title: Text(strings.enableProgressiveTempo),
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _NumberField(
              label: strings.startBpm,
              value: config.startBpm,
              enabled: config.enabled,
              onChanged: (value) => onChanged(config.copyWith(startBpm: value)),
            ),
            _NumberField(
              label: strings.targetBpm,
              value: config.targetBpm,
              enabled: config.enabled,
              onChanged: (value) =>
                  onChanged(config.copyWith(targetBpm: value)),
            ),
            _NumberField(
              label: strings.stepBpm,
              value: config.stepBpm,
              enabled: config.enabled,
              onChanged: (value) => onChanged(config.copyWith(stepBpm: value)),
            ),
            _NumberField(
              label: strings.everyBars,
              value: config.everyBars,
              enabled: config.enabled,
              onChanged: (value) =>
                  onChanged(config.copyWith(everyBars: value)),
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
