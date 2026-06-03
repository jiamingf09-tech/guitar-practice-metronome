import 'gap_click_config.dart';
import 'speed_trainer_config.dart';

enum TimeSignature {
  fourFour(4, 4, '4/4'),
  threeFour(3, 4, '3/4'),
  sixEight(6, 8, '6/8'),
  fiveFour(5, 4, '5/4');

  const TimeSignature(this.beatsPerBar, this.beatUnit, this.label);

  final int beatsPerBar;
  final int beatUnit;
  final String label;

  static TimeSignature fromName(String? name) {
    return TimeSignature.values.firstWhere(
      (value) => value.name == name,
      orElse: () => TimeSignature.fourFour,
    );
  }
}

enum RhythmSubdivision {
  whole('whole', 'Whole'),
  half('half', 'Half'),
  quarter('quarter', 'Quarter'),
  eighth('eighth', 'Eighth'),
  sixteenth('sixteenth', 'Sixteenth'),
  eighthSixteenth('eighthSixteenth', 'Eighth + Sixteenth'),
  sixteenthEighth('sixteenthEighth', 'Sixteenth + Eighth'),
  triplet('triplet', 'Triplet');

  const RhythmSubdivision(this.storageName, this.label);

  final String storageName;
  final String label;

  static const _rhythmUnitsPerBeat = 12;

  List<int> get _beatPatternUnits {
    return switch (this) {
      RhythmSubdivision.whole => const [],
      RhythmSubdivision.half => const [],
      RhythmSubdivision.quarter => const [_rhythmUnitsPerBeat],
      RhythmSubdivision.eighth => const [6, 6],
      RhythmSubdivision.sixteenth => const [3, 3, 3, 3],
      RhythmSubdivision.eighthSixteenth => const [6, 3, 3],
      RhythmSubdivision.sixteenthEighth => const [3, 3, 6],
      RhythmSubdivision.triplet => const [4, 4, 4],
    };
  }

  int ticksPerBar(TimeSignature timeSignature) {
    return switch (this) {
      RhythmSubdivision.whole => 1,
      RhythmSubdivision.half => 2,
      _ => timeSignature.beatsPerBar * _beatPatternUnits.length,
    };
  }

  int markerCount(TimeSignature timeSignature) {
    return switch (this) {
      RhythmSubdivision.whole => 1,
      RhythmSubdivision.half => 2,
      _ => _beatPatternUnits.length,
    };
  }

  int beatForTick(int tickIndex, TimeSignature timeSignature) {
    return switch (this) {
      RhythmSubdivision.whole => 1,
      RhythmSubdivision.half =>
        ((tickIndex * timeSignature.beatsPerBar) ~/ 2) + 1,
      _ => (tickIndex ~/ _beatPatternUnits.length) + 1,
    };
  }

  int markerForTick(int tickIndex, TimeSignature timeSignature) {
    return switch (this) {
      RhythmSubdivision.whole => 1,
      RhythmSubdivision.half => tickIndex + 1,
      _ => (tickIndex % _beatPatternUnits.length) + 1,
    };
  }

  Duration intervalAfterTick({
    required int bpm,
    required TimeSignature timeSignature,
    required int tickIndex,
  }) {
    final beatMicros = 60000000 / bpm;
    final microseconds = switch (this) {
      RhythmSubdivision.whole => beatMicros * timeSignature.beatsPerBar,
      RhythmSubdivision.half => beatMicros * timeSignature.beatsPerBar / 2,
      _ =>
        beatMicros *
            _beatPatternUnits[tickIndex % _beatPatternUnits.length] /
            _rhythmUnitsPerBeat,
    };
    return Duration(microseconds: microseconds.round());
  }

  static RhythmSubdivision fromName(String? name) {
    return RhythmSubdivision.values.firstWhere(
      (value) => value.name == name || value.storageName == name,
      orElse: () => RhythmSubdivision.quarter,
    );
  }
}

class MetronomeConfig {
  const MetronomeConfig({
    this.bpm = 80,
    this.timeSignature = TimeSignature.fourFour,
    this.subdivision = RhythmSubdivision.quarter,
    this.countInEnabled = false,
    this.speedTrainer = const SpeedTrainerConfig(),
    this.gapClick = const GapClickConfig(),
    this.practiceMinutes,
  });

  final int bpm;
  final TimeSignature timeSignature;
  final RhythmSubdivision subdivision;
  final bool countInEnabled;
  final SpeedTrainerConfig speedTrainer;
  final GapClickConfig gapClick;
  final int? practiceMinutes;

  MetronomeConfig copyWith({
    int? bpm,
    TimeSignature? timeSignature,
    RhythmSubdivision? subdivision,
    bool? countInEnabled,
    SpeedTrainerConfig? speedTrainer,
    GapClickConfig? gapClick,
    int? practiceMinutes,
    bool clearPracticeMinutes = false,
  }) {
    return MetronomeConfig(
      bpm: (bpm ?? this.bpm).clamp(30, 300),
      timeSignature: timeSignature ?? this.timeSignature,
      subdivision: subdivision ?? this.subdivision,
      countInEnabled: countInEnabled ?? this.countInEnabled,
      speedTrainer: (speedTrainer ?? this.speedTrainer).normalized(),
      gapClick: (gapClick ?? this.gapClick).normalized(),
      practiceMinutes: clearPracticeMinutes
          ? null
          : practiceMinutes ?? this.practiceMinutes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bpm': bpm,
      'timeSignature': timeSignature.name,
      'subdivision': subdivision.name,
      'countInEnabled': countInEnabled,
      'speedTrainer': speedTrainer.toJson(),
      'gapClick': gapClick.toJson(),
      'practiceMinutes': practiceMinutes,
    };
  }

  factory MetronomeConfig.fromJson(Map<String, dynamic> json) {
    return MetronomeConfig(
      bpm: json['bpm'] as int? ?? 80,
      timeSignature: TimeSignature.fromName(json['timeSignature'] as String?),
      subdivision: RhythmSubdivision.fromName(json['subdivision'] as String?),
      countInEnabled: json['countInEnabled'] as bool? ?? false,
      speedTrainer: SpeedTrainerConfig.fromJson(
        (json['speedTrainer'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      ),
      gapClick: GapClickConfig.fromJson(
        (json['gapClick'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      ),
      practiceMinutes: json['practiceMinutes'] as int?,
    );
  }
}
