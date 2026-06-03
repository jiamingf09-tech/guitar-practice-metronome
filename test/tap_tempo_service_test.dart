import 'package:flutter_test/flutter_test.dart';
import 'package:guitar_metronome/services/tap_tempo_service.dart';

void main() {
  test('tap tempo averages recent intervals into a clamped BPM', () {
    final service = TapTempoService();
    final start = DateTime(2026, 1, 1, 12);

    expect(service.registerTap(start), isNull);
    expect(
      service.registerTap(start.add(const Duration(milliseconds: 500))),
      120,
    );
    expect(
      service.registerTap(start.add(const Duration(milliseconds: 1000))),
      120,
    );
    expect(
      service.registerTap(start.add(const Duration(milliseconds: 1500))),
      120,
    );
    expect(
      service.registerTap(start.add(const Duration(milliseconds: 2000))),
      120,
    );
  });

  test('tap tempo resets when taps are more than two seconds apart', () {
    final service = TapTempoService();
    final start = DateTime(2026, 1, 1, 12);

    service.registerTap(start);
    expect(
      service.registerTap(start.add(const Duration(milliseconds: 500))),
      120,
    );
    expect(
      service.registerTap(start.add(const Duration(milliseconds: 2600))),
      isNull,
    );
  });
}
