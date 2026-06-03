import 'package:flutter/material.dart';

import '../models/metronome_config.dart';

class TimeSignatureSelector extends StatelessWidget {
  const TimeSignatureSelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final TimeSignature value;
  final ValueChanged<TimeSignature> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<TimeSignature>(
      segments: TimeSignature.values
          .map(
            (signature) => ButtonSegment<TimeSignature>(
              value: signature,
              label: Text(signature.label),
            ),
          )
          .toList(),
      selected: {value},
      onSelectionChanged: (selection) => onChanged(selection.first),
      showSelectedIcon: false,
    );
  }
}
