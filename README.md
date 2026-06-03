# Guitar Practice Metronome

[![CI / Release](https://github.com/jiamingf09-tech/guitar-practice-metronome/actions/workflows/ci.yml/badge.svg)](https://github.com/jiamingf09-tech/guitar-practice-metronome/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/jiamingf09-tech/guitar-practice-metronome)](https://github.com/jiamingf09-tech/guitar-practice-metronome/releases/latest)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

[中文](README.zh.md) | English

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
| Android | arm64-v8a / armeabi-v7a / x86_64 | ✅ |
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
- **Speed trainer** — auto-ramp BPM from a start value to a target over a set number of bars
- **Silent bars (gap click)** — alternate N normal bars with M silent bars to train internal pulse
- **Practice timer** — set a session length; metronome stops automatically when time is up

### Presets
- Save, load, and delete named practice presets
- Each preset stores the full configuration (BPM, time signature, subdivision, speed trainer, gap click, timer)

### UI / UX
- Material 3 dark theme
- English / 中文 (Simplified Chinese) UI switch — persisted across sessions
- No ads, no accounts, no network access required

---

## Download

Grab the latest build for your platform from the [Releases page](https://github.com/jiamingf09-tech/guitar-practice-metronome/releases/latest).

| Platform | File | Notes |
|---|---|---|
| macOS arm64 | `GuitarMetronome-macos-arm64.zip` | Extract and drag to Applications |
| Windows x64 | `GuitarMetronome-windows-x64.zip` | Extract and run `guitar_metronome.exe` |
| Linux x64 | `GuitarMetronome-linux-x64.tar.gz` | Extract and run `guitar_metronome` |
| Android | `GuitarMetronome-android.apk` | Enable "Install unknown apps" in Settings |
| iOS | `GuitarMetronome-ios-unsigned.ipa` | Requires sideloading (AltStore / Sideloadly) |

> **macOS note:** The app is not notarized. On first launch, right-click → Open to bypass Gatekeeper.

---

## Build from Source

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.41 (stable channel)
- macOS builds: Xcode 15+, CocoaPods
- Windows builds: Visual Studio 2022 with "Desktop development with C++"
- Linux builds: `clang`, `cmake`, `ninja-build`, `pkg-config`, `libgtk-3-dev`
- Android builds: Android Studio or `sdkmanager` with Build-Tools 34
- iOS builds: Xcode 15+, iOS 12+ deployment target

```sh
# Clone
git clone https://github.com/jiamingf09-tech/guitar-practice-metronome.git
cd guitar-practice-metronome

# Fetch dependencies
flutter pub get

# Run on your platform
flutter run -d macos      # or: windows, linux, chrome
```

### Release builds

```sh
flutter build macos   --release
flutter build windows --release
flutter build linux   --release
flutter build apk     --release          # Android APK
flutter build ios     --release --no-codesign  # iOS (unsigned)
```

### Verify

```sh
flutter analyze
flutter test
```

---

## Architecture Notes

### Audio Engine

`AudioEngine` is a thin interface (`playAccentClick` / `playNormalClick`).
`DefaultAudioEngine` synthesises short sine-tone WAV files at startup (no bundled assets)
and plays them through `audioplayers` with warm-up pooling to minimise latency.
To swap in a native backend, implement `AudioEngine` and inject it in `main()`.

### Metronome Clock

The clock runs a `Timer`-based recursive loop in `MetronomeController`.
Each tick derives the next interval from the live `MetronomeConfig` (supports BPM ramp
during speed training). State is a `ValueNotifier<MetronomeState>` — widgets rebuild
only when relevant state changes.

---

## Contributing

1. Fork the repo and create a feature branch
2. `flutter analyze && flutter test` must both be clean
3. One feature or fix per PR
4. UI strings go in `lib/services/app_strings.dart` in both `AppLanguage.en` and `AppLanguage.zh`

---

## License

MIT — see [LICENSE](LICENSE).
