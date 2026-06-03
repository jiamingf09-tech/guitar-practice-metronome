class SpeedTrainerConfig {
  const SpeedTrainerConfig({
    this.enabled = false,
    this.startBpm = 60,
    this.targetBpm = 120,
    this.stepBpm = 5,
    this.everyBars = 8,
  });

  final bool enabled;
  final int startBpm;
  final int targetBpm;
  final int stepBpm;
  final int everyBars;

  SpeedTrainerConfig copyWith({
    bool? enabled,
    int? startBpm,
    int? targetBpm,
    int? stepBpm,
    int? everyBars,
  }) {
    return SpeedTrainerConfig(
      enabled: enabled ?? this.enabled,
      startBpm: startBpm ?? this.startBpm,
      targetBpm: targetBpm ?? this.targetBpm,
      stepBpm: stepBpm ?? this.stepBpm,
      everyBars: everyBars ?? this.everyBars,
    ).normalized();
  }

  SpeedTrainerConfig normalized() {
    final normalizedStart = startBpm.clamp(30, 300);
    final normalizedTarget = targetBpm.clamp(30, 300);
    return SpeedTrainerConfig(
      enabled: enabled,
      startBpm: normalizedStart,
      targetBpm: normalizedTarget < normalizedStart
          ? normalizedStart
          : normalizedTarget,
      stepBpm: stepBpm.clamp(1, 50),
      everyBars: everyBars.clamp(1, 128),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'startBpm': startBpm,
      'targetBpm': targetBpm,
      'stepBpm': stepBpm,
      'everyBars': everyBars,
    };
  }

  factory SpeedTrainerConfig.fromJson(Map<String, dynamic> json) {
    return SpeedTrainerConfig(
      enabled: json['enabled'] as bool? ?? false,
      startBpm: json['startBpm'] as int? ?? 60,
      targetBpm: json['targetBpm'] as int? ?? 120,
      stepBpm: json['stepBpm'] as int? ?? 5,
      everyBars: json['everyBars'] as int? ?? 8,
    ).normalized();
  }
}
