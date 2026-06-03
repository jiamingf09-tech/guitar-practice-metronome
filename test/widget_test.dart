import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guitar_metronome/app.dart';
import 'package:guitar_metronome/services/app_locale_controller.dart';
import 'package:guitar_metronome/services/audio_engine.dart';
import 'package:guitar_metronome/services/preset_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAudioEngine implements AudioEngine {
  @override
  Future<void> init() async {}

  @override
  Future<void> playAccentClick() async {}

  @override
  Future<void> playNormalClick() async {}

  @override
  Future<void> dispose() async {}
}

void main() {
  testWidgets('renders the Guitar Metronome MVP shell', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final presetStore = await PresetStore.create();
    final localeController = await AppLocaleController.create();

    await tester.pumpWidget(
      GuitarMetronomeApp(
        audioEngine: _FakeAudioEngine(),
        presetStore: presetStore,
        localeController: localeController,
      ),
    );

    expect(find.text('Guitar Metronome'), findsOneWidget);
    expect(find.text('Manual Practice'), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
    expect(find.text('Tap Tempo'), findsOneWidget);
    expect(find.text('Speed Trainer'), findsOneWidget);
    expect(find.text('Gap Click / Silent Bar'), findsOneWidget);
    expect(find.text('Whole'), findsOneWidget);
    expect(find.text('Half'), findsOneWidget);
    expect(find.text('Eighth + Sixteenth'), findsOneWidget);
    expect(find.text('Sixteenth + Eighth'), findsOneWidget);
  });

  testWidgets('switches settings language to Chinese', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final presetStore = await PresetStore.create();
    final localeController = await AppLocaleController.create();

    await tester.pumpWidget(
      GuitarMetronomeApp(
        audioEngine: _FakeAudioEngine(),
        presetStore: presetStore,
        localeController: localeController,
      ),
    );

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Language'), findsOneWidget);

    await tester.tap(find.text('Chinese'));
    await tester.pumpAndSettle();

    expect(find.text('设置'), findsOneWidget);
    expect(find.text('语言'), findsOneWidget);
    expect(localeController.language, AppLanguage.chinese);
  });
}
