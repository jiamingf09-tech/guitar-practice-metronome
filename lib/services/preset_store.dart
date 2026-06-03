import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/metronome_config.dart';
import '../models/practice_preset.dart';

class PresetStore {
  PresetStore._(this._preferences);

  static const _storageKey = 'guitar_metronome.custom_presets.v1';

  final SharedPreferences _preferences;

  static Future<PresetStore> create() async {
    final preferences = await SharedPreferences.getInstance();
    return PresetStore._(preferences);
  }

  Future<List<PracticePreset>> loadAllPresets() async {
    final customPresets = await loadCustomPresets();
    return [...PracticePreset.builtIns(), ...customPresets];
  }

  Future<List<PracticePreset>> loadCustomPresets() async {
    final raw = _preferences.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }

    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      return const [];
    }

    return decoded
        .whereType<Map>()
        .map((item) => PracticePreset.fromJson(item.cast<String, dynamic>()))
        .where((preset) => !preset.isBuiltIn)
        .toList(growable: false);
  }

  Future<PracticePreset> savePreset({
    required String name,
    required MetronomeConfig config,
  }) async {
    final trimmedName = name.trim().isEmpty ? 'Untitled Preset' : name.trim();
    final preset = PracticePreset(
      id: 'custom-${DateTime.now().microsecondsSinceEpoch}',
      name: trimmedName,
      config: MetronomeConfig.fromJson(config.toJson()),
    );
    final presets = await loadCustomPresets();
    await _saveCustomPresets([...presets, preset]);
    return preset;
  }

  Future<void> deletePreset(String presetId) async {
    final presets = await loadCustomPresets();
    await _saveCustomPresets(
      presets.where((preset) => preset.id != presetId).toList(growable: false),
    );
  }

  Future<void> _saveCustomPresets(List<PracticePreset> presets) async {
    final encoded = jsonEncode(
      presets.map((preset) => preset.toJson()).toList(),
    );
    await _preferences.setString(_storageKey, encoded);
  }
}
