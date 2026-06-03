# Guitar Practice Metronome

[![CI / Release](https://github.com/jiamingf09-tech/guitar-practice-metronome/actions/workflows/ci.yml/badge.svg)](https://github.com/jiamingf09-tech/guitar-practice-metronome/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/jiamingf09-tech/guitar-practice-metronome)](https://github.com/jiamingf09-tech/guitar-practice-metronome/releases/latest)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A cross-platform metronome built with Flutter, designed for serious guitar practice.
Beyond a basic beat, it includes speed training, silent-bar practice, subdivisions,
tap tempo, and a preset system — all in a clean dark UI with English / 中文 support.

---

## Platforms

| Platform | Architecture | Status |
|---|---|---|
| macOS | arm64 | ✅ |
| Windows | x64 | ✅ |
| Linux | x64 | ✅ |
| Android | arm64 / x64 | ✅ |
| iOS | arm64 | ✅ |

---

## Features

### Core Metronome
- **BPM range** 30–300 with slider, +/− step buttons, and keyboard-friendly input
- **Time signatures** — 4/4 · 3/4 · 6/8 · 5/4
- **Subdivisions** — Whole · Half · Quarter · Eighth · Sixteenth · Eighth+Sixteenth · Sixteenth+Eighth · Triplet
- **Count-in** — 1–4 silent lead-in bars before playback starts
- **Beat indicator** — visual flash distinguishes accent beat from subdivisions

### Practice Tools
- **Tap tempo** — tap any key or button to detect your natural tempo
- **Speed trainer** — auto-ramp BPM from a start value to a target over a set number of bars, with configurable step size
- **Silent bars (gap click)** — alternate N normal bars with M silent bars to train internal pulse
- **Practice timer** — set a session length; metronome stops automatically when time is up

### Presets
- Save, load, and delete named practice presets
- Each preset stores the full metronome configuration (BPM, time signature, subdivision, speed trainer, gap click, timer)

### UI / UX
- Material 3 dark theme
- English / 中文 (Simplified Chinese) UI switch — persisted across sessions
- No ads, no accounts, no network access required

---

## Download

Grab the latest build for your platform from the [Releases page](https://github.com/jiamingf09-tech/guitar-practice-metronome/releases/latest).

| Platform | File |
|---|---|
| macOS arm64 | `GuitarMetronome-macos-arm64.zip` — extract and drag to Applications |
| Windows x64 | `GuitarMetronome-windows-x64.zip` — extract and run `guitar_metronome.exe` |
| Linux x64 | `GuitarMetronome-linux-x64.tar.gz` — extract and run `guitar_metronome` |

> **macOS note:** The app is not notarized. On first launch, right-click → Open to bypass Gatekeeper.

---

## Build from Source

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.41 (stable channel)
- For macOS: Xcode 15+, CocoaPods
- For Windows: Visual Studio 2022 with "Desktop development with C++"
- For Linux: `clang`, `cmake`, `ninja-build`, `pkg-config`, `libgtk-3-dev`

```sh
# Clone
git clone https://github.com/jiamingf09-tech/guitar-practice-metronome.git
cd guitar-practice-metronome

# Fetch dependencies
flutter pub get

# Run on your platform
flutter run -d macos      # or: windows, linux
```

### Build release binaries

```sh
flutter build macos   --release
flutter build windows --release
flutter build linux   --release
```

### Run tests

```sh
flutter analyze
flutter test
```

---

## Project Structure

```
lib/
├── main.dart                     # Entry point — initialises services, wires DI
├── app.dart                      # MaterialApp, theme, locale switcher
│
├── models/
│   ├── metronome_config.dart     # Immutable config value object (BPM, time sig, etc.)
│   ├── speed_trainer_config.dart # Speed-ramp parameters
│   ├── gap_click_config.dart     # Silent-bar parameters
│   └── practice_preset.dart     # Named preset (name + MetronomeConfig)
│
├── services/
│   ├── audio_engine.dart         # AudioEngine interface + DefaultAudioEngine (WAV synth)
│   ├── metronome_controller.dart # Clock loop, tick scheduling, state management
│   ├── tap_tempo_service.dart    # Rolling-average tap detection
│   ├── preset_store.dart         # SharedPreferences-backed preset persistence
│   └── app_locale_controller.dart# Language preference (EN / ZH), ChangeNotifier
│
├── pages/
│   ├── metronome_page.dart       # Main screen
│   ├── presets_page.dart         # Preset browser
│   └── settings_page.dart       # Language switch
│
└── widgets/
    ├── beat_indicator.dart
    ├── bpm_control.dart
    ├── subdivision_selector.dart
    ├── time_signature_selector.dart
    ├── speed_trainer_panel.dart
    ├── gap_click_panel.dart
    ├── practice_timer_panel.dart
    └── preset_list.dart
```

---

## Architecture Notes

### Audio Engine

`AudioEngine` is a thin interface with two methods — `playAccentClick()` and `playNormalClick()`.
`DefaultAudioEngine` generates short sine-tone WAV files at startup (no bundled assets needed)
and plays them through `audioplayers` with warm-up pooling to minimise latency.

To swap in a native engine (AVAudioEngine on macOS/iOS, Oboe on Android, WASAPI on Windows)
without touching any UI code, implement `AudioEngine` and pass it into `main()`.

### Metronome Clock

The clock runs on a `Timer`-based loop inside `MetronomeController`. Each tick computes
the next interval from the current `MetronomeConfig` (BPM, subdivision, speed-trainer ramp)
and schedules itself recursively. State is exposed as a `ValueNotifier<MetronomeState>`
so widgets rebuild only when they need to.

### Localisation

`AppStrings` is a hand-written string table (no `.arb` files) keyed on `AppLanguage`.
`AppLocaleController` wraps a `ChangeNotifier` and persists the choice via `shared_preferences`.

---

## CI / CD

GitHub Actions ([`.github/workflows/ci.yml`](.github/workflows/ci.yml)):

| Job | Trigger | Runner |
|---|---|---|
| `test` (× 3 OS in parallel) | every push / PR | macos-latest, windows-latest, ubuntu-latest |
| `build-macos` | `v*.*.*` tag only, after tests pass | macos-latest |
| `build-windows` | same | windows-latest |
| `build-linux` | same | ubuntu-latest |
| `release` | after all three builds pass | ubuntu-latest |

Pushing a `v*.*.*` tag triggers the full pipeline and publishes a GitHub Release with
all three platform archives attached.

---

## Contributing

1. Fork the repo and create a feature branch
2. Run `flutter analyze && flutter test` — both must be clean before opening a PR
3. Keep PRs focused; one feature or fix per PR
4. UI strings go into `lib/services/app_strings.dart` in both `AppLanguage.en` and `AppLanguage.zh`

---

## License

MIT — see [LICENSE](LICENSE).
