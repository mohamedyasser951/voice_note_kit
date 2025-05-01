import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<void> playSound(String assetPath) async {
  try {
    final player = AudioPlayer();
    final byteData = await rootBundle.load(assetPath);
    final file = File('${(await getTemporaryDirectory()).path}/temp_sound.mp3');
    await file.writeAsBytes(byteData.buffer.asUint8List());

    await player.setFilePath(file.path);
    await player.play();
  } catch (e) {
    rethrow;
  }
}
