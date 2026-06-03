class GapClickConfig {
  const GapClickConfig({
    this.enabled = false,
    this.playBars = 3,
    this.muteBars = 1,
  });

  final bool enabled;
  final int playBars;
  final int muteBars;

  GapClickConfig copyWith({bool? enabled, int? playBars, int? muteBars}) {
    return GapClickConfig(
      enabled: enabled ?? this.enabled,
      playBars: playBars ?? this.playBars,
      muteBars: muteBars ?? this.muteBars,
    ).normalized();
  }

  GapClickConfig normalized() {
    return GapClickConfig(
      enabled: enabled,
      playBars: playBars.clamp(1, 64),
      muteBars: muteBars.clamp(1, 64),
    );
  }

  Map<String, dynamic> toJson() {
    return {'enabled': enabled, 'playBars': playBars, 'muteBars': muteBars};
  }

  factory GapClickConfig.fromJson(Map<String, dynamic> json) {
    return GapClickConfig(
      enabled: json['enabled'] as bool? ?? false,
      playBars: json['playBars'] as int? ?? 3,
      muteBars: json['muteBars'] as int? ?? 1,
    ).normalized();
  }
}
