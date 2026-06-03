import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/gap_click_config.dart';
import '../models/metronome_config.dart';
import '../models/practice_preset.dart';
import '../models/speed_trainer_config.dart';
import 'audio_engine.dart';

class MetronomeController extends ChangeNotifier {
  MetronomeController({
    required AudioEngine audioEngine,
    MetronomeConfig initialConfig = const MetronomeConfig(
      bpm: 80,
      subdivision: RhythmSubdivision.eighth,
    ),
  }) : _audioEngine = audioEngine,
       _config = initialConfig {
    _remainingPractice = _initialPracticeDuration;
  }

  final AudioEngine _audioEngine;

  MetronomeConfig _config;
  Timer? _tickTimer;
  Timer? _practiceTimer;

  bool _isPlaying = false;
  bool _isCountIn = false;
  bool _isGapMuted = false;
  bool _practiceClockStarted = false;
  int _currentBar = 1;
  int _currentBeat = 1;
  int _currentSubdivisionTick = 1;
  int _nextTickIndex = 0;
  int _completedOfficialBars = 0;
  Duration? _remainingPractice;
  String _activePresetName = 'Manual Practice';

  MetronomeConfig get config => _config;
  bool get isPlaying => _isPlaying;
  bool get isCountIn => _isCountIn;
  bool get isGapMuted => _isGapMuted;
  int get currentBar => _currentBar;
  int get currentBeat => _currentBeat;
  int get currentSubdivisionTick => _currentSubdivisionTick;
  int get completedOfficialBars => _completedOfficialBars;
  Duration? get remainingPractice => _remainingPractice;
  String get activePresetName => _activePresetName;

  Duration? get _initialPracticeDuration {
    final minutes = _config.practiceMinutes;
    return minutes == null ? null : Duration(minutes: minutes);
  }

  void togglePlayback() {
    if (_isPlaying) {
      stop();
    } else {
      start();
    }
  }

  void start() {
    if (_isPlaying) {
      return;
    }

    if (_config.speedTrainer.enabled) {
      _config = _config.copyWith(bpm: _config.speedTrainer.startBpm);
    }

    _resetPosition();
    _isPlaying = true;
    _isCountIn = _config.countInEnabled;
    _practiceClockStarted = false;
    _remainingPractice = _initialPracticeDuration;

    if (!_isCountIn) {
      _startPracticeClock();
    }

    notifyListeners();
    _fireTick();
  }

  void stop() {
    _tickTimer?.cancel();
    _practiceTimer?.cancel();
    _tickTimer = null;
    _practiceTimer = null;
    _isPlaying = false;
    _isCountIn = false;
    _isGapMuted = false;
    _practiceClockStarted = false;
    _remainingPractice = _initialPracticeDuration;
    _resetPosition();
    notifyListeners();
  }

  void setBpm(int bpm) {
    _config = _config.copyWith(bpm: bpm);
    _activePresetName = 'Manual Practice';
    notifyListeners();
  }

  void adjustBpm(int delta) => setBpm(_config.bpm + delta);

  void setTimeSignature(TimeSignature timeSignature) {
    _config = _config.copyWith(timeSignature: timeSignature);
    _activePresetName = 'Manual Practice';
    _resetPosition();
    notifyListeners();
  }

  void setSubdivision(RhythmSubdivision subdivision) {
    _config = _config.copyWith(subdivision: subdivision);
    _activePresetName = 'Manual Practice';
    _resetPosition();
    notifyListeners();
  }

  void setCountInEnabled(bool enabled) {
    _config = _config.copyWith(countInEnabled: enabled);
    _activePresetName = 'Manual Practice';
    notifyListeners();
  }

  void setPracticeMinutes(int? minutes) {
    _config = _config.copyWith(
      practiceMinutes: minutes,
      clearPracticeMinutes: minutes == null,
    );
    _remainingPractice = _initialPracticeDuration;
    _activePresetName = 'Manual Practice';
    notifyListeners();
  }

  void updateSpeedTrainer(SpeedTrainerConfig speedTrainer) {
    _config = _config.copyWith(speedTrainer: speedTrainer);
    _activePresetName = 'Manual Practice';
    notifyListeners();
  }

  void updateGapClick(GapClickConfig gapClick) {
    _config = _config.copyWith(gapClick: gapClick);
    _activePresetName = 'Manual Practice';
    notifyListeners();
  }

  void loadPreset(PracticePreset preset) {
    stop();
    _config = MetronomeConfig.fromJson(preset.config.toJson());
    _activePresetName = preset.name;
    _remainingPractice = _initialPracticeDuration;
    _resetPosition();
    notifyListeners();
  }

  void markPresetSaved(String presetName) {
    _activePresetName = presetName;
    notifyListeners();
  }

  void _fireTick() {
    if (!_isPlaying) {
      return;
    }

    final isAccent = _nextTickIndex == 0;
    final visibleBar = _isCountIn ? 0 : _completedOfficialBars + 1;
    _currentBar = visibleBar;
    _currentBeat = _config.subdivision.beatForTick(
      _nextTickIndex,
      _config.timeSignature,
    );
    _currentSubdivisionTick = _config.subdivision.markerForTick(
      _nextTickIndex,
      _config.timeSignature,
    );
    _isGapMuted = !_isCountIn && _shouldMuteBar(visibleBar);

    if (!_isGapMuted) {
      unawaited(
        isAccent
            ? _audioEngine.playAccentClick()
            : _audioEngine.playNormalClick(),
      );
    }

    final nextInterval = _config.subdivision.intervalAfterTick(
      bpm: _config.bpm,
      timeSignature: _config.timeSignature,
      tickIndex: _nextTickIndex,
    );

    notifyListeners();
    _advanceCounters();

    _tickTimer = Timer(nextInterval, _fireTick);
  }

  void _advanceCounters() {
    final ticksPerBar = _config.subdivision.ticksPerBar(_config.timeSignature);
    _nextTickIndex++;
    if (_nextTickIndex < ticksPerBar) {
      return;
    }

    _nextTickIndex = 0;
    _handleBarComplete();
  }

  void _handleBarComplete() {
    if (_isCountIn) {
      _isCountIn = false;
      _startPracticeClock();
      return;
    }

    _completedOfficialBars++;
    _applySpeedTrainerIfNeeded();
  }

  void _applySpeedTrainerIfNeeded() {
    final speedTrainer = _config.speedTrainer;
    if (!speedTrainer.enabled ||
        speedTrainer.everyBars <= 0 ||
        _completedOfficialBars == 0 ||
        _completedOfficialBars % speedTrainer.everyBars != 0) {
      return;
    }

    final nextBpm = (_config.bpm + speedTrainer.stepBpm).clamp(
      speedTrainer.startBpm,
      speedTrainer.targetBpm,
    );
    if (nextBpm != _config.bpm) {
      _config = _config.copyWith(bpm: nextBpm);
      notifyListeners();
    }
  }

  bool _shouldMuteBar(int bar) {
    final gapClick = _config.gapClick;
    if (!gapClick.enabled) {
      return false;
    }

    final cycle = gapClick.playBars + gapClick.muteBars;
    final cyclePosition = (bar - 1) % cycle;
    return cyclePosition >= gapClick.playBars;
  }

  void _startPracticeClock() {
    if (_practiceClockStarted || _remainingPractice == null) {
      return;
    }

    _practiceClockStarted = true;
    _practiceTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final remaining = _remainingPractice;
      if (remaining == null) {
        return;
      }

      final next = remaining - const Duration(seconds: 1);
      if (next <= Duration.zero) {
        _remainingPractice = Duration.zero;
        notifyListeners();
        stop();
        return;
      }

      _remainingPractice = next;
      notifyListeners();
    });
  }

  void _resetPosition() {
    _currentBar = 1;
    _currentBeat = 1;
    _currentSubdivisionTick = 1;
    _nextTickIndex = 0;
    _completedOfficialBars = 0;
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    _practiceTimer?.cancel();
    unawaited(_audioEngine.dispose());
    super.dispose();
  }
}
