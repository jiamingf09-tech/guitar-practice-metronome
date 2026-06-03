import 'package:flutter/material.dart';

import 'app.dart';
import 'services/app_locale_controller.dart';
import 'services/audio_engine.dart';
import 'services/preset_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final audioEngine = DefaultAudioEngine();
  await audioEngine.init();
  final presetStore = await PresetStore.create();
  final localeController = await AppLocaleController.create();

  runApp(
    GuitarMetronomeApp(
      audioEngine: audioEngine,
      presetStore: presetStore,
      localeController: localeController,
    ),
  );
}
