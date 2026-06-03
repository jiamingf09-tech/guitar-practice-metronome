import '../models/gap_click_config.dart';
import '../models/metronome_config.dart';
import '../models/speed_trainer_config.dart';
import 'app_locale_controller.dart';

class AppStrings {
  const AppStrings(this.appLanguage);

  final AppLanguage appLanguage;

  bool get _zh => appLanguage == AppLanguage.chinese;

  String get appTitle => 'Guitar Metronome';
  String get manualPractice => _zh ? '手动练习' : 'Manual Practice';
  String get presetsTooltip => _zh ? '预设' : 'Presets';
  String get settingsTooltip => _zh ? '设置' : 'Settings';
  String get settings => _zh ? '设置' : 'Settings';
  String get language => _zh ? '语言' : 'Language';
  String get english => _zh ? '英文' : 'English';
  String get chinese => _zh ? '中文' : 'Chinese';

  String get running => _zh ? '播放中' : 'RUNNING';
  String get stopped => _zh ? '已停止' : 'STOPPED';
  String get start => _zh ? '开始' : 'Start';
  String get stop => _zh ? '停止' : 'Stop';
  String get tapTempo => _zh ? '点按测速' : 'Tap Tempo';

  String get practiceSetup => _zh ? '练习设置' : 'Practice Setup';
  String get timeSignature => _zh ? '拍号' : 'Time Signature';
  String get subdivision => _zh ? '细分' : 'Subdivision';
  String get countIn => _zh ? '预备拍' : 'Count-in';
  String get countInSubtitle =>
      _zh ? '正式练习前先播放一小节' : 'Play one bar before the exercise starts';
  String get load => _zh ? '加载' : 'Load';
  String get save => _zh ? '保存' : 'Save';
  String get cancel => _zh ? '取消' : 'Cancel';
  String get off => _zh ? '关闭' : 'Off';
  String get bpm => 'BPM';

  String get saveCurrentPreset => _zh ? '保存当前预设' : 'Save Current Preset';
  String get presetName => _zh ? '预设名称' : 'Preset name';
  String get presetHint => _zh ? '拨片热身练习' : 'Alternate picking warmup';
  String savedPreset(String name) => _zh ? '已保存“$name”' : 'Saved "$name"';

  String get practicePresets => _zh ? '练习预设' : 'Practice Presets';
  String deletedPreset(String name) => _zh ? '已删除“$name”' : 'Deleted "$name"';
  String couldNotLoadPresets(Object error) =>
      _zh ? '无法加载预设：$error' : 'Could not load presets: $error';
  String get noPresetsSaved => _zh ? '还没有保存的预设。' : 'No presets saved yet.';
  String get loadPresetTooltip => _zh ? '加载预设' : 'Load preset';
  String get deletePresetTooltip => _zh ? '删除预设' : 'Delete preset';

  String get speedTrainer => _zh ? '渐进提速' : 'Speed Trainer';
  String speedTrainerSummary(SpeedTrainerConfig config) {
    if (!config.enabled) {
      return off;
    }
    return _zh
        ? '${config.startBpm} -> ${config.targetBpm} BPM，每 ${config.everyBars} 小节 +${config.stepBpm}'
        : '${config.startBpm} -> ${config.targetBpm} BPM, +${config.stepBpm} every ${config.everyBars} bars';
  }

  String get enableProgressiveTempo =>
      _zh ? '开启渐进提速训练' : 'Enable progressive tempo';
  String get startBpm => _zh ? '起始 BPM' : 'Start BPM';
  String get targetBpm => _zh ? '目标 BPM' : 'Target BPM';
  String get stepBpm => _zh ? '步进 BPM' : 'Step BPM';
  String get everyBars => _zh ? '每几小节' : 'Every Bars';

  String get gapClick => _zh ? '静音小节训练' : 'Gap Click / Silent Bar';
  String gapClickSummary(GapClickConfig config) {
    if (!config.enabled) {
      return off;
    }
    return _zh
        ? '响 ${config.playBars} 小节，静音 ${config.muteBars} 小节'
        : 'Play ${config.playBars}, mute ${config.muteBars}';
  }

  String get enableSilentBarTraining =>
      _zh ? '开启静音小节训练' : 'Enable silent bar training';
  String get playBars => _zh ? '响几小节' : 'Play Bars';
  String get muteBars => _zh ? '静音几小节' : 'Mute Bars';

  String get practiceTimer => _zh ? '练习计时器' : 'Practice Timer';
  String get unlimited => _zh ? '不限时' : 'Unlimited';
  String minutesLabel(int minutes) => _zh ? '$minutes 分钟' : '${minutes}m';

  String beatStatus({
    required bool isCountIn,
    required bool isGapMuted,
    required bool isPlaying,
    required int currentBar,
  }) {
    if (isCountIn) {
      return _zh ? '预备拍' : 'COUNT-IN';
    }
    if (isGapMuted) {
      return _zh ? '静音小节' : 'SILENT BAR';
    }
    if (isPlaying) {
      return _zh ? '第 $currentBar 小节' : 'BAR $currentBar';
    }
    return _zh ? '就绪' : 'READY';
  }

  String subdivisionLabel(RhythmSubdivision subdivision) {
    switch (subdivision) {
      case RhythmSubdivision.whole:
        return _zh ? '全音符' : 'Whole';
      case RhythmSubdivision.half:
        return _zh ? '二分音符' : 'Half';
      case RhythmSubdivision.quarter:
        return _zh ? '四分音符' : 'Quarter';
      case RhythmSubdivision.eighth:
        return _zh ? '八分音符' : 'Eighth';
      case RhythmSubdivision.sixteenth:
        return _zh ? '十六分音符' : 'Sixteenth';
      case RhythmSubdivision.eighthSixteenth:
        return _zh ? '八/十六音符' : 'Eighth + Sixteenth';
      case RhythmSubdivision.sixteenthEighth:
        return _zh ? '十六/八音符' : 'Sixteenth + Eighth';
      case RhythmSubdivision.triplet:
        return _zh ? '三连音' : 'Triplet';
    }
  }

  String presetDisplayName(String name) {
    if (!_zh) {
      return name;
    }

    return switch (name) {
      'Manual Practice' => manualPractice,
      'Untitled Preset' => '未命名预设',
      'Alternate Picking Beginner' => '交替拨弦入门',
      'Palm Mute Eighth Notes' => '闷音八分音符',
      'Funk Sixteenth Rhythm' => '放克十六分节奏',
      'Blues Shuffle Triplet' => '布鲁斯 Shuffle 三连音',
      _ => name,
    };
  }

  String get audioEngine => _zh ? '音频引擎' : 'Audio Engine';
  String get audioEngineDescription => _zh
      ? '当前 MVP 使用 DefaultAudioEngine。后续可替换 AudioEngine 实现以接入 AVAudioEngine、Oboe 或 WASAPI。'
      : 'MVP uses DefaultAudioEngine. Replace the AudioEngine implementation for AVAudioEngine, Oboe, or WASAPI later.';
}
