# Guitar Metronome

A cross-platform Flutter MVP for electric guitar practice. It combines a basic
metronome with practice-oriented tools: tap tempo, count-in, subdivisions,
speed training, silent bars, practice timers, local presets, and an English /
Chinese UI switch.

## Targets

- macOS
- Windows
- Android
- iOS

## Run

```sh
flutter pub get
flutter run -d macos
```

Use another Flutter device id for Android, iOS, or Windows:

```sh
flutter devices
flutter run -d <device-id>
```

## Verify

```sh
flutter analyze
flutter test
```

## Audio Engine Boundary

The MVP audio boundary is `lib/services/audio_engine.dart`.

- `AudioEngine` defines the app-facing click interface.
- `DefaultAudioEngine` currently generates short WAV clicks in Dart and plays
  them through `audioplayers`.
- Future native engines can replace this implementation without moving audio
  code into UI widgets:
  - iOS/macOS: AVAudioEngine
  - Android: Oboe
  - Windows: WASAPI
