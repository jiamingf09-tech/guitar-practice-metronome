import 'metronome_config.dart';
import 'gap_click_config.dart';
import 'speed_trainer_config.dart';

class PracticePreset {
  const PracticePreset({
    required this.id,
    required this.name,
    required this.config,
    this.isBuiltIn = false,
  });

  final String id;
  final String name;
  final MetronomeConfig config;
  final bool isBuiltIn;

  PracticePreset copyWith({
    String? id,
    String? name,
    MetronomeConfig? config,
    bool? isBuiltIn,
  }) {
    return PracticePreset(
      id: id ?? this.id,
      name: name ?? this.name,
      config: config ?? this.config,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'config': config.toJson(),
      'isBuiltIn': isBuiltIn,
    };
  }

  factory PracticePreset.fromJson(Map<String, dynamic> json) {
    return PracticePreset(
      id:
          json['id'] as String? ??
          'preset-${DateTime.now().microsecondsSinceEpoch}',
      name: json['name'] as String? ?? 'Untitled Preset',
      config: MetronomeConfig.fromJson(
        (json['config'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      ),
      isBuiltIn: json['isBuiltIn'] as bool? ?? false,
    );
  }

  static List<PracticePreset> builtIns() {
    return const [
      PracticePreset(
        id: 'builtin-alternate-picking-beginner',
        name: 'Alternate Picking Beginner',
        isBuiltIn: true,
        config: MetronomeConfig(
          bpm: 60,
          timeSignature: TimeSignature.fourFour,
          subdivision: RhythmSubdivision.sixteenth,
          speedTrainer: SpeedTrainerConfig(
            enabled: true,
            startBpm: 60,
            targetBpm: 120,
            stepBpm: 5,
            everyBars: 8,
          ),
        ),
      ),
      PracticePreset(
        id: 'builtin-palm-mute-eighth-notes',
        name: 'Palm Mute Eighth Notes',
        isBuiltIn: true,
        config: MetronomeConfig(
          bpm: 90,
          timeSignature: TimeSignature.fourFour,
          subdivision: RhythmSubdivision.eighth,
          gapClick: GapClickConfig(enabled: true, playBars: 4, muteBars: 1),
        ),
      ),
      PracticePreset(
        id: 'builtin-funk-sixteenth-rhythm',
        name: 'Funk Sixteenth Rhythm',
        isBuiltIn: true,
        config: MetronomeConfig(
          bpm: 80,
          timeSignature: TimeSignature.fourFour,
          subdivision: RhythmSubdivision.sixteenth,
          gapClick: GapClickConfig(enabled: true, playBars: 3, muteBars: 1),
        ),
      ),
      PracticePreset(
        id: 'builtin-blues-shuffle-triplet',
        name: 'Blues Shuffle Triplet',
        isBuiltIn: true,
        config: MetronomeConfig(
          bpm: 70,
          timeSignature: TimeSignature.fourFour,
          subdivision: RhythmSubdivision.triplet,
          speedTrainer: SpeedTrainerConfig(
            enabled: true,
            startBpm: 70,
            targetBpm: 110,
            stepBpm: 5,
            everyBars: 12,
          ),
        ),
      ),
    ];
  }
}
