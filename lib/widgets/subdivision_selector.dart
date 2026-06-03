import 'package:flutter/material.dart';

import '../models/metronome_config.dart';
import '../services/app_strings.dart';

class SubdivisionSelector extends StatelessWidget {
  const SubdivisionSelector({
    required this.value,
    required this.strings,
    required this.onChanged,
    super.key,
  });

  final RhythmSubdivision value;
  final AppStrings strings;
  final ValueChanged<RhythmSubdivision> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: RhythmSubdivision.values.map((subdivision) {
        final selected = subdivision == value;
        return ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 112, minHeight: 46),
          child: OutlinedButton(
            onPressed: () => onChanged(subdivision),
            style: OutlinedButton.styleFrom(
              backgroundColor: selected
                  ? colorScheme.primaryContainer
                  : Colors.transparent,
              foregroundColor: selected
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurface,
              side: BorderSide(
                color: selected ? colorScheme.primary : colorScheme.outline,
                width: selected ? 1.6 : 1,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              textStyle: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            child: Text(
              strings.subdivisionLabel(subdivision),
              textAlign: TextAlign.center,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }).toList(),
    );
  }
}
