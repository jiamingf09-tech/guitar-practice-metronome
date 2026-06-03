import 'package:flutter/material.dart';

import '../models/practice_preset.dart';
import '../services/app_strings.dart';
import '../services/metronome_controller.dart';
import '../services/preset_store.dart';
import '../widgets/preset_list.dart';

class PresetsPage extends StatefulWidget {
  const PresetsPage({
    required this.controller,
    required this.presetStore,
    required this.strings,
    super.key,
  });

  final MetronomeController controller;
  final PresetStore presetStore;
  final AppStrings strings;

  @override
  State<PresetsPage> createState() => _PresetsPageState();
}

class _PresetsPageState extends State<PresetsPage> {
  late Future<List<PracticePreset>> _presetsFuture;

  @override
  void initState() {
    super.initState();
    _presetsFuture = widget.presetStore.loadAllPresets();
  }

  Future<void> _deletePreset(PracticePreset preset) async {
    await widget.presetStore.deletePreset(preset.id);
    if (!mounted) {
      return;
    }
    setState(() {
      _presetsFuture = widget.presetStore.loadAllPresets();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(widget.strings.deletedPreset(preset.name))),
    );
  }

  void _loadPreset(PracticePreset preset) {
    widget.controller.loadPreset(preset);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.strings.practicePresets)),
      body: FutureBuilder<List<PracticePreset>>(
        future: _presetsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(widget.strings.couldNotLoadPresets(snapshot.error!)),
            );
          }

          return PresetList(
            presets: snapshot.data ?? const [],
            strings: widget.strings,
            onLoad: _loadPreset,
            onDelete: _deletePreset,
          );
        },
      ),
    );
  }
}
