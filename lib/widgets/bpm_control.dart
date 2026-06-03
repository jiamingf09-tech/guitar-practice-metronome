import 'package:flutter/material.dart';

class BpmControl extends StatelessWidget {
  const BpmControl({
    required this.bpm,
    required this.onBpmChanged,
    required this.onAdjust,
    super.key,
  });

  final int bpm;
  final ValueChanged<int> onBpmChanged;
  final ValueChanged<int> onAdjust;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$bpm',
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 88,
                height: 0.9,
                fontWeight: FontWeight.w800,
                color: colorScheme.primary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 10),
              child: Text(
                'BPM',
                style: theme.textTheme.titleLarge?.copyWith(
                  letterSpacing: 0,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Slider(
          min: 30,
          max: 300,
          divisions: 270,
          value: bpm.toDouble(),
          onChanged: (value) => onBpmChanged(value.round()),
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: const [-10, -5, -1, 1, 5, 10]
              .map(
                (delta) => OutlinedButton(
                  onPressed: () => onAdjust(delta),
                  child: Text(delta > 0 ? '+$delta' : '$delta'),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
