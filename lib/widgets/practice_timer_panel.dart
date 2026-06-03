import 'package:flutter/material.dart';

import '../services/app_strings.dart';

class PracticeTimerPanel extends StatelessWidget {
  const PracticeTimerPanel({
    required this.practiceMinutes,
    required this.remainingPractice,
    required this.strings,
    required this.onChanged,
    super.key,
  });

  final int? practiceMinutes;
  final Duration? remainingPractice;
  final AppStrings strings;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedValue = practiceMinutes ?? 0;
    final remaining = remainingPractice == null
        ? strings.unlimited
        : _formatDuration(remainingPractice!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.timer_outlined),
            const SizedBox(width: 8),
            Text(strings.practiceTimer, style: theme.textTheme.titleMedium),
            const Spacer(),
            Text(
              remaining,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SegmentedButton<int>(
            segments: [
              ButtonSegment(value: 0, label: Text(strings.unlimited)),
              ButtonSegment(value: 5, label: Text(strings.minutesLabel(5))),
              ButtonSegment(value: 10, label: Text(strings.minutesLabel(10))),
              ButtonSegment(value: 20, label: Text(strings.minutesLabel(20))),
              ButtonSegment(value: 30, label: Text(strings.minutesLabel(30))),
            ],
            selected: {selectedValue},
            showSelectedIcon: false,
            onSelectionChanged: (selection) {
              final value = selection.first;
              onChanged(value == 0 ? null : value);
            },
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
