import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'pages/metronome_page.dart';
import 'services/app_locale_controller.dart';
import 'services/app_strings.dart';
import 'services/audio_engine.dart';
import 'services/metronome_controller.dart';
import 'services/preset_store.dart';

class GuitarMetronomeApp extends StatefulWidget {
  const GuitarMetronomeApp({
    required this.audioEngine,
    required this.presetStore,
    required this.localeController,
    super.key,
  });

  final AudioEngine audioEngine;
  final PresetStore presetStore;
  final AppLocaleController localeController;

  @override
  State<GuitarMetronomeApp> createState() => _GuitarMetronomeAppState();
}

class _GuitarMetronomeAppState extends State<GuitarMetronomeApp> {
  late final MetronomeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MetronomeController(audioEngine: widget.audioEngine);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFFFB020),
      brightness: Brightness.dark,
    );

    return AnimatedBuilder(
      animation: widget.localeController,
      builder: (context, _) {
        final strings = AppStrings(widget.localeController.language);

        return MaterialApp(
          title: strings.appTitle,
          locale: widget.localeController.locale,
          supportedLocales: AppLanguage.values
              .map((language) => language.locale)
              .toList(growable: false),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: colorScheme,
            scaffoldBackgroundColor: const Color(0xFF0E1116),
            textTheme: Typography.whiteMountainView.apply(
              bodyColor: const Color(0xFFE7EAF0),
              displayColor: const Color(0xFFF7F8FA),
            ),
            sliderTheme: SliderThemeData(
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 13),
              activeTrackColor: colorScheme.primary,
              inactiveTrackColor: colorScheme.surfaceContainerHighest,
            ),
            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                minimumSize: const Size(56, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(56, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            segmentedButtonTheme: SegmentedButtonThemeData(
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          home: MetronomePage(
            controller: _controller,
            presetStore: widget.presetStore,
            localeController: widget.localeController,
            strings: strings,
          ),
        );
      },
    );
  }
}
