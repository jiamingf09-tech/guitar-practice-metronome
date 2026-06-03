import 'package:flutter_test/flutter_test.dart';
import 'package:guitar_metronome/models/metronome_config.dart';
import 'package:guitar_metronome/services/app_locale_controller.dart';
import 'package:guitar_metronome/services/app_strings.dart';

void main() {
  test('subdivision tick counts include whole and half notes', () {
    expect(RhythmSubdivision.whole.ticksPerBar(TimeSignature.fourFour), 1);
    expect(RhythmSubdivision.half.ticksPerBar(TimeSignature.fourFour), 2);
    expect(RhythmSubdivision.quarter.ticksPerBar(TimeSignature.fourFour), 4);
    expect(RhythmSubdivision.eighth.ticksPerBar(TimeSignature.fourFour), 8);
    expect(RhythmSubdivision.sixteenth.ticksPerBar(TimeSignature.fourFour), 16);
    expect(
      RhythmSubdivision.eighthSixteenth.ticksPerBar(TimeSignature.fourFour),
      12,
    );
    expect(
      RhythmSubdivision.sixteenthEighth.ticksPerBar(TimeSignature.fourFour),
      12,
    );
    expect(RhythmSubdivision.triplet.ticksPerBar(TimeSignature.fourFour), 12);
  });

  test('mixed subdivisions use uneven eighth and sixteenth timing', () {
    expect(
      RhythmSubdivision.eighthSixteenth.intervalAfterTick(
        bpm: 60,
        timeSignature: TimeSignature.fourFour,
        tickIndex: 0,
      ),
      const Duration(milliseconds: 500),
    );
    expect(
      RhythmSubdivision.eighthSixteenth.intervalAfterTick(
        bpm: 60,
        timeSignature: TimeSignature.fourFour,
        tickIndex: 1,
      ),
      const Duration(milliseconds: 250),
    );
    expect(
      RhythmSubdivision.sixteenthEighth.intervalAfterTick(
        bpm: 60,
        timeSignature: TimeSignature.fourFour,
        tickIndex: 0,
      ),
      const Duration(milliseconds: 250),
    );
    expect(
      RhythmSubdivision.sixteenthEighth.intervalAfterTick(
        bpm: 60,
        timeSignature: TimeSignature.fourFour,
        tickIndex: 2,
      ),
      const Duration(milliseconds: 500),
    );
  });

  test('subdivision labels support Chinese whole and half notes', () {
    final strings = AppStrings(AppLanguage.chinese);

    expect(strings.subdivisionLabel(RhythmSubdivision.whole), '全音符');
    expect(strings.subdivisionLabel(RhythmSubdivision.half), '二分音符');
    expect(
      strings.subdivisionLabel(RhythmSubdivision.eighthSixteenth),
      '八/十六音符',
    );
    expect(
      strings.subdivisionLabel(RhythmSubdivision.sixteenthEighth),
      '十六/八音符',
    );
  });
}
