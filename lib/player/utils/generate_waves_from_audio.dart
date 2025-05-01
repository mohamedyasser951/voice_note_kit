import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voice_note_kit/player/player_enums/player_enums.dart';
import 'package:http/http.dart' as http;

Future<List<double>> extrectWaveform(File audioFile) async {
  try {
    final outputFile = File('${audioFile.path}_waveform.wave');

    final waveformStream = JustWaveform.extract(
      audioInFile: audioFile,
      waveOutFile: outputFile,
    );

    final waveform = await waveformStream.last;

    // Normalize amplitudes between 0.0 and 1.0
    return waveform.waveform!.data.map((e) => e.toDouble() / 32768.0).toList();
  } catch (e) {
    log(e.toString());
    return [];
  }
}

Future<List<double>> generateWaveform(
    AudioType audioType, String? audioPath) async {
  try {
    File? audioFile;

    if (audioType == AudioType.assets && audioPath != null) {
      final byteData = await rootBundle.load(audioPath);
      final tempDir = await getTemporaryDirectory();
      audioFile = File('${tempDir.path}/asset_audio.mp3');
      await audioFile.writeAsBytes(byteData.buffer.asUint8List());
    } else if (audioType == AudioType.url && audioPath != null) {
      final response = await http.get(Uri.parse(audioPath));
      final tempDir = await getTemporaryDirectory();
      audioFile = File('${tempDir.path}/url_audio.mp3');
      await audioFile.writeAsBytes(response.bodyBytes);
    } else if (audioType == AudioType.directFile && audioPath != null) {
      audioFile = File(audioPath);
    }

    if (audioFile != null) {
      List<double> waves = await extrectWaveform(audioFile);
      return waves;
    }

    return [];
  } catch (e) {
    return [];
  }
}
