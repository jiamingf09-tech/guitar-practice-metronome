import 'package:flutter/material.dart';

import '../services/app_locale_controller.dart';
import '../services/app_strings.dart';
import '../services/metronome_controller.dart';
import '../services/preset_store.dart';
import '../services/tap_tempo_service.dart';
import '../widgets/beat_indicator.dart';
import '../widgets/bpm_control.dart';
import '../widgets/gap_click_panel.dart';
import '../widgets/practice_timer_panel.dart';
import '../widgets/speed_trainer_panel.dart';
import '../widgets/subdivision_selector.dart';
import '../widgets/time_signature_selector.dart';
import 'presets_page.dart';
import 'settings_page.dart';

class MetronomePage extends StatefulWidget {
  const MetronomePage({
    required this.controller,
    required this.presetStore,
    required this.localeController,
    required this.strings,
    super.key,
  });

  final MetronomeController controller;
  final PresetStore presetStore;
  final AppLocaleController localeController;
  final AppStrings strings;

  @override
  State<MetronomePage> createState() => _MetronomePageState();
}

class _MetronomePageState extends State<MetronomePage> {
  final TapTempoService _tapTempoService = TapTempoService();

  MetronomeController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.strings.appTitle),
            actions: [
              IconButton(
                tooltip: widget.strings.presetsTooltip,
                icon: const Icon(Icons.library_music_outlined),
                onPressed: _openPresets,
              ),
              IconButton(
                tooltip: widget.strings.settingsTooltip,
                icon: const Icon(Icons.settings_outlined),
                onPressed: _openSettings,
              ),
            ],
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final desktop = constraints.maxWidth >= 920;
                final maxWidth = desktop ? 1180.0 : 680.0;

                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      child: desktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: _MainPracticePanel(
                                    controller: controller,
                                    strings: widget.strings,
                                    onTapTempo: _handleTapTempo,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 4,
                                  child: _ControlsPanel(
                                    controller: controller,
                                    strings: widget.strings,
                                    onSavePreset: _savePreset,
                                    onOpenPresets: _openPresets,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _MainPracticePanel(
                                  controller: controller,
                                  strings: widget.strings,
                                  onTapTempo: _handleTapTempo,
                                ),
                                const SizedBox(height: 16),
                                _ControlsPanel(
                                  controller: controller,
                                  strings: widget.strings,
                                  onSavePreset: _savePreset,
                                  onOpenPresets: _openPresets,
                                ),
                              ],
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _handleTapTempo() {
    final bpm = _tapTempoService.registerTap();
    if (bpm != null) {
      controller.setBpm(bpm);
    }
  }

  Future<void> _savePreset() async {
    final nameController = TextEditingController(
      text: controller.activePresetName == 'Manual Practice'
          ? ''
          : controller.activePresetName,
    );
    final name = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(widget.strings.saveCurrentPreset),
          content: TextField(
            controller: nameController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: widget.strings.presetName,
              hintText: widget.strings.presetHint,
            ),
            onSubmitted: (value) => Navigator.of(context).pop(value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(widget.strings.cancel),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(nameController.text),
              icon: const Icon(Icons.save_outlined),
              label: Text(widget.strings.save),
            ),
          ],
        );
      },
    );
    nameController.dispose();

    if (name == null) {
      return;
    }

    final preset = await widget.presetStore.savePreset(
      name: name,
      config: controller.config,
    );
    controller.markPresetSaved(preset.name);

    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(widget.strings.savedPreset(preset.name))),
    );
  }

  Future<void> _openPresets() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => PresetsPage(
          controller: controller,
          presetStore: widget.presetStore,
          strings: widget.strings,
        ),
      ),
    );
  }

  Future<void> _openSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            SettingsPage(localeController: widget.localeController),
      ),
    );
  }
}

class _MainPracticePanel extends StatelessWidget {
  const _MainPracticePanel({
    required this.controller,
    required this.strings,
    required this.onTapTempo,
  });

  final MetronomeController controller;
  final AppStrings strings;
  final VoidCallback onTapTempo;

  @override
  Widget build(BuildContext context) {
    final config = controller.config;
    final theme = Theme.of(context);

    return _SurfacePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.presetDisplayName(controller.activePresetName),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${config.timeSignature.label} · ${strings.subdivisionLabel(config.subdivision)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusPill(
                label: controller.isPlaying ? strings.running : strings.stopped,
                active: controller.isPlaying,
              ),
            ],
          ),
          const SizedBox(height: 24),
          BpmControl(
            bpm: config.bpm,
            onBpmChanged: controller.setBpm,
            onAdjust: controller.adjustBpm,
          ),
          const SizedBox(height: 28),
          BeatIndicator(
            beatsPerBar: config.timeSignature.beatsPerBar,
            currentBeat: controller.currentBeat,
            currentSubdivisionTick: controller.currentSubdivisionTick,
            subdivisionMarkers: config.subdivision.markerCount(
              config.timeSignature,
            ),
            isPlaying: controller.isPlaying,
            isCountIn: controller.isCountIn,
            isGapMuted: controller.isGapMuted,
            currentBar: controller.currentBar,
            strings: strings,
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: controller.togglePlayback,
                  icon: Icon(
                    controller.isPlaying ? Icons.stop : Icons.play_arrow,
                  ),
                  label: Text(
                    controller.isPlaying ? strings.stop : strings.start,
                  ),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(58),
                    textStyle: theme.textTheme.titleMedium,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onTapTempo,
                  icon: const Icon(Icons.touch_app_outlined),
                  label: Text(strings.tapTempo),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(58),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ControlsPanel extends StatelessWidget {
  const _ControlsPanel({
    required this.controller,
    required this.strings,
    required this.onSavePreset,
    required this.onOpenPresets,
  });

  final MetronomeController controller;
  final AppStrings strings;
  final VoidCallback onSavePreset;
  final VoidCallback onOpenPresets;

  @override
  Widget build(BuildContext context) {
    final config = controller.config;
    final theme = Theme.of(context);

    return _SurfacePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            strings.practiceSetup,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          Text(strings.timeSignature, style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: TimeSignatureSelector(
              value: config.timeSignature,
              onChanged: controller.setTimeSignature,
            ),
          ),
          const SizedBox(height: 18),
          Text(strings.subdivision, style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          SubdivisionSelector(
            value: config.subdivision,
            strings: strings,
            onChanged: controller.setSubdivision,
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: config.countInEnabled,
            onChanged: controller.setCountInEnabled,
            title: Text(strings.countIn),
            subtitle: Text(strings.countInSubtitle),
            secondary: const Icon(Icons.flag_outlined),
          ),
          const Divider(height: 24),
          SpeedTrainerPanel(
            config: config.speedTrainer,
            strings: strings,
            onChanged: controller.updateSpeedTrainer,
          ),
          GapClickPanel(
            config: config.gapClick,
            strings: strings,
            onChanged: controller.updateGapClick,
          ),
          const Divider(height: 24),
          PracticeTimerPanel(
            practiceMinutes: config.practiceMinutes,
            remainingPractice: controller.remainingPractice,
            strings: strings,
            onChanged: controller.setPracticeMinutes,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onOpenPresets,
                  icon: const Icon(Icons.library_music_outlined),
                  label: Text(strings.load),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onSavePreset,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(strings.save),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SurfacePanel extends StatelessWidget {
  const _SurfacePanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(width: double.infinity, child: child),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = active ? colorScheme.primary : colorScheme.outline;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
