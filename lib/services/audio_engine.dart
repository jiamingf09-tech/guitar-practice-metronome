import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';

abstract class AudioEngine {
  Future<void> init();
  Future<void> playAccentClick();
  Future<void> playNormalClick();
  Future<void> dispose();
}

class DefaultAudioEngine implements AudioEngine {
  AudioPool? _accentPool;
  AudioPool? _normalPool;

  @override
  Future<void> init() async {
    final soundDirectory = Directory(
      '${Directory.systemTemp.path}/guitar_metronome_clicks',
    );
    await soundDirectory.create(recursive: true);

    final accentFile = File('${soundDirectory.path}/accent_click.wav');
    final normalFile = File('${soundDirectory.path}/normal_click.wav');

    await accentFile.writeAsBytes(
      _buildClickWav(frequency: 1600, durationMs: 28, gain: 0.82),
      flush: true,
    );
    await normalFile.writeAsBytes(
      _buildClickWav(frequency: 940, durationMs: 22, gain: 0.58),
      flush: true,
    );

    _accentPool = await AudioPool.create(
      source: DeviceFileSource(accentFile.path, mimeType: 'audio/wav'),
      minPlayers: 6,
      maxPlayers: 12,
      playerMode: PlayerMode.mediaPlayer,
    );
    _normalPool = await AudioPool.create(
      source: DeviceFileSource(normalFile.path, mimeType: 'audio/wav'),
      minPlayers: 12,
      maxPlayers: 24,
      playerMode: PlayerMode.mediaPlayer,
    );
    await Future.wait([_warmUp(_accentPool), _warmUp(_normalPool)]);
  }

  @override
  Future<void> playAccentClick() => _play(_accentPool);

  @override
  Future<void> playNormalClick() => _play(_normalPool);

  Future<void> _play(AudioPool? pool) async {
    if (pool == null) {
      return;
    }

    try {
      await pool.start();
    } on Object {
      // Keep the metronome clock running even if the platform audio backend
      // drops a single click.
    }
  }

  Future<void> _warmUp(AudioPool? pool) async {
    if (pool == null) {
      return;
    }

    try {
      final stop = await pool.start(volume: 0);
      await stop();
    } on Object {
      // Warm-up is best effort only.
    }
  }

  @override
  Future<void> dispose() async {
    await Future.wait([
      if (_accentPool != null) _accentPool!.dispose(),
      if (_normalPool != null) _normalPool!.dispose(),
    ]);
  }
}

Uint8List _buildClickWav({
  required double frequency,
  required int durationMs,
  required double gain,
  int sampleRate = 44100,
}) {
  final sampleCount = (sampleRate * durationMs / 1000).round();
  final dataSize = sampleCount * 2;
  final bytes = ByteData(44 + dataSize);

  void writeString(int offset, String value) {
    for (var i = 0; i < value.length; i++) {
      bytes.setUint8(offset + i, value.codeUnitAt(i));
    }
  }

  writeString(0, 'RIFF');
  bytes.setUint32(4, 36 + dataSize, Endian.little);
  writeString(8, 'WAVE');
  writeString(12, 'fmt ');
  bytes.setUint32(16, 16, Endian.little);
  bytes.setUint16(20, 1, Endian.little);
  bytes.setUint16(22, 1, Endian.little);
  bytes.setUint32(24, sampleRate, Endian.little);
  bytes.setUint32(28, sampleRate * 2, Endian.little);
  bytes.setUint16(32, 2, Endian.little);
  bytes.setUint16(34, 16, Endian.little);
  writeString(36, 'data');
  bytes.setUint32(40, dataSize, Endian.little);

  for (var i = 0; i < sampleCount; i++) {
    final t = i / sampleRate;
    final envelope = math.exp(-t * 135);
    final sample = math.sin(2 * math.pi * frequency * t) * envelope * gain;
    bytes.setInt16(44 + i * 2, (sample * 32767).round(), Endian.little);
  }

  return bytes.buffer.asUint8List();
}
