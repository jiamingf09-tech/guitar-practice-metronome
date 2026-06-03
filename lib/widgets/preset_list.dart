import 'package:flutter/material.dart';

import '../models/practice_preset.dart';
import '../services/app_strings.dart';

class PresetList extends StatelessWidget {
  const PresetList({
    required this.presets,
    required this.strings,
    required this.onLoad,
    required this.onDelete,
    super.key,
  });

  final List<PracticePreset> presets;
  final AppStrings strings;
  final ValueChanged<PracticePreset> onLoad;
  final ValueChanged<PracticePreset> onDelete;

  @override
  Widget build(BuildContext context) {
    if (presets.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(strings.noPresetsSaved),
        ),
      );
    }

    return ListView.separated(
      itemCount: presets.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final preset = presets[index];
        final config = preset.config;
        return ListTile(
          leading: CircleAvatar(
            child: Icon(
              preset.isBuiltIn ? Icons.electric_bolt : Icons.bookmark,
            ),
          ),
          title: Text(strings.presetDisplayName(preset.name)),
          subtitle: Text(
            '${config.bpm} BPM · ${config.timeSignature.label} · ${strings.subdivisionLabel(config.subdivision)}',
          ),
          trailing: Wrap(
            spacing: 4,
            children: [
              IconButton(
                tooltip: strings.loadPresetTooltip,
                icon: const Icon(Icons.playlist_play),
                onPressed: () => onLoad(preset),
              ),
              if (!preset.isBuiltIn)
                IconButton(
                  tooltip: strings.deletePresetTooltip,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => onDelete(preset),
                ),
            ],
          ),
          onTap: () => onLoad(preset),
        );
      },
    );
  }
}
