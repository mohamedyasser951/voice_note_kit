// ignore_for_file: avoid_print

import 'dart:io'; // For handling recorded audio files
import 'package:flutter/material.dart';
import 'package:voice_note_kit/voice_note_kit.dart'; // Importing the custom package

void main() {
  runApp(const MyApp()); // Starting point of the app
}

/// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Voice Note Kit')),
        body:
            const VoiceRecorderExample(), // Main screen that shows recorder & player
      ),
    );
  }
}

/// This widget manages recording and playback of audio using the voice_note_kit
class VoiceRecorderExample extends StatefulWidget {
  const VoiceRecorderExample({super.key});

  @override
  _VoiceRecorderExampleState createState() => _VoiceRecorderExampleState();
}

class _VoiceRecorderExampleState extends State<VoiceRecorderExample> {
  File? recordedFile; // To hold the recorded audio file locally

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ------------------------ Recorder Section ------------------------
            VoiceRecorderWidget(
              iconSize: 100,
              showTimerText: true,
              showSwipeLeftToCancel: true,

              // Optional: Add custom sounds for recording events
              // startSoundAsset: "assets/start_warning.mp3",
              // stopSoundAsset: "assets/start_warning.mp3",

              // When recording is finished
              onRecorded: (file) {
                setState(() {
                  recordedFile = file;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Recording saved: ${file.path}')),
                );
              },

              // When error occurs during recording
              onError: (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $error')),
                );
              },

              // If recording was cancelled
              actionWhenCancel: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Recording Cancelled')),
                );
              },

              maxRecordDuration: const Duration(seconds: 60),
              permissionNotGrantedMessage: 'Microphone permission required',
              dragToLeftText: 'Swipe left to cancel recording',
              dragToLeftTextStyle: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 18,
              ),
              cancelDoneText: 'Recording cancelled',
              backgroundColor: Colors.blueAccent,
              cancelHintColor: Colors.red,
              iconColor: Colors.white,
              timerFontSize: 18,
            ),

            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 30),

            // ------------------------ URL Audio Playback Example ------------------------
            AudioPlayerWidget(
              autoPlay: false,
              autoLoad: true,
              audioPath:
                  "https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/fx/engine-10.ogg",
              audioType: AudioType.url,
              playerStyle: PlayerStyle.style5,
              textDirection: TextDirection.rtl,
              size: 60,
              progressBarHeight: 5,
              backgroundColor: Colors.blue,
              progressBarColor: Colors.blue,
              progressBarBackgroundColor: Colors.white,
              iconColor: Colors.white,
              shapeType: PlayIconShapeType.circular,
              showProgressBar: true,
              showTimer: true,
              width: 300,
              audioSpeeds: const [0.5, 1.0, 1.5, 2.0, 3.0],
              onSeek: (value) => print('Seeked to: $value'),
              onError: (message) => print('Error: $message'),
              onPause: () => print("Paused"),
              onPlay: (isPlaying) => print("Playing: $isPlaying"),
              onSpeedChange: (speed) => print("Speed: $speed"),
            ),

            const SizedBox(height: 30),

            // ------------------------ Asset Audio Example (Style 5) ------------------------
            const AudioPlayerWidget(
              autoLoad: true,
              audioPath: "assets/start_warning.mp3",
              audioType: AudioType.assets,
              textDirection: TextDirection.ltr,
              size: 60,
              progressBarHeight: 5,
              backgroundColor: Color(0xff25D366),
              progressBarColor: Color(0xff25D366),
              progressBarBackgroundColor: Colors.white,
              iconColor: Colors.white,
              shapeType: PlayIconShapeType.circular,
              playerStyle: PlayerStyle.style5,
              width: 300,
              showProgressBar: true,
              showTimer: true,
            ),

            const SizedBox(height: 30),

            // ------------------------ Recorded Audio (Style 1) ------------------------
            recordedFile != null
                ? AudioPlayerWidget(
                    autoLoad: true,
                    audioPath: recordedFile?.path,
                    size: 60,
                    progressBarHeight: 7,
                    backgroundColor: Colors.blueAccent,
                    progressBarColor: Colors.blue,
                    progressBarBackgroundColor: Colors.white,
                    iconColor: Colors.white,
                    shapeType: PlayIconShapeType.circular,
                    playerStyle: PlayerStyle.style1,
                    textDirection: TextDirection.rtl,
                    width: 300,
                    showProgressBar: true,
                    showTimer: true,
                  )
                : const SizedBox.shrink(),

            const SizedBox(height: 30),

            // ------------------------ Asset Audio (Style 4) ------------------------
            const AudioPlayerWidget(
              autoLoad: true,
              audioPath: "assets/start_warning.mp3",
              audioType: AudioType.assets,
              size: 30,
              progressBarHeight: 5,
              backgroundColor: Colors.blue,
              progressBarColor: Color.fromARGB(255, 62, 167, 252),
              progressBarBackgroundColor: Colors.white,
              iconColor: Colors.white,
              shapeType: PlayIconShapeType.circular,
              playerStyle: PlayerStyle.stlye4,
              width: 300,
              showProgressBar: true,
              showTimer: true,
            ),

            const SizedBox(height: 30),

            // ------------------------ Recorded Audio (Style 2) ------------------------
            recordedFile != null
                ? AudioPlayerWidget(
                    autoLoad: true,
                    audioPath: recordedFile?.path,
                    size: 60,
                    progressBarHeight: 5,
                    backgroundColor: Colors.blueAccent,
                    progressBarColor: Colors.blue,
                    progressBarBackgroundColor: Colors.white,
                    iconColor: Colors.white,
                    shapeType: PlayIconShapeType.circular,
                    playerStyle: PlayerStyle.style2,
                    width: 300,
                    showProgressBar: true,
                    showTimer: true,
                  )
                : const SizedBox.shrink(),

            const SizedBox(height: 30),

            // ------------------------ Recorded Audio (Style 3) ------------------------
            recordedFile != null
                ? AudioPlayerWidget(
                    autoLoad: true,
                    audioPath: recordedFile?.path,
                    size: 60,
                    progressBarHeight: 5,
                    backgroundColor: Colors.blueAccent,
                    progressBarColor: Colors.blue,
                    progressBarBackgroundColor: Colors.white,
                    iconColor: Colors.white,
                    shapeType: PlayIconShapeType.circular,
                    playerStyle: PlayerStyle.style3,
                    width: 300,
                    showProgressBar: true,
                    showTimer: true,
                  )
                : const SizedBox.shrink(),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
