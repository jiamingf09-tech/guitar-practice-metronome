import 'package:flutter/material.dart';

import '../services/app_strings.dart';

class BeatIndicator extends StatelessWidget {
  const BeatIndicator({
    required this.beatsPerBar,
    required this.currentBeat,
    required this.currentSubdivisionTick,
    required this.subdivisionMarkers,
    required this.isPlaying,
    required this.isCountIn,
    required this.isGapMuted,
    required this.currentBar,
    required this.strings,
    super.key,
  });

  final int beatsPerBar;
  final int currentBeat;
  final int currentSubdivisionTick;
  final int subdivisionMarkers;
  final bool isPlaying;
  final bool isCountIn;
  final bool isGapMuted;
  final int currentBar;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final status = strings.beatStatus(
      isCountIn: isCountIn,
      isGapMuted: isGapMuted,
      isPlaying: isPlaying,
      currentBar: currentBar,
    );

    return Column(
      children: [
        Text(
          status,
          style: theme.textTheme.labelLarge?.copyWith(
            color: isGapMuted ? colorScheme.tertiary : colorScheme.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final dotSize = (constraints.maxWidth / (beatsPerBar * 1.8)).clamp(
              34.0,
              64.0,
            );
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(beatsPerBar, (index) {
                final beat = index + 1;
                final active = isPlaying && beat == currentBeat;
                final isDownbeat = beat == 1;
                final size = isDownbeat ? dotSize * 1.15 : dotSize;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 90),
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: active
                          ? (isDownbeat
                                ? colorScheme.primary
                                : colorScheme.secondary)
                          : colorScheme.surfaceContainerHighest,
                      border: Border.all(
                        width: isDownbeat ? 3 : 1,
                        color: isDownbeat
                            ? colorScheme.primary
                            : colorScheme.outlineVariant,
                      ),
                      boxShadow: active
                          ? [
                              BoxShadow(
                                color:
                                    (isDownbeat
                                            ? colorScheme.primary
                                            : colorScheme.secondary)
                                        .withValues(alpha: 0.38),
                                blurRadius: 22,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '$beat',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: active
                              ? colorScheme.onPrimary
                              : colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(subdivisionMarkers, (index) {
            final tick = index + 1;
            final active = isPlaying && currentSubdivisionTick == tick;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 80),
              width: active ? 30 : 22,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: active
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
              ),
            );
          }),
        ),
      ],
    );
  }
}
