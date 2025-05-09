// ignore_for_file: avoid_print

import 'dart:io'; // For handling recorded audio files
import 'package:flutter/material.dart';
import 'package:voice_note_kit/player/utils/audio_player_controller.dart';
import 'package:voice_note_kit/voice_note_kit.dart'; // Importing the custom package for voice recording and playback

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
        appBar:
            AppBar(title: const Text('Voice Note Kit')), // AppBar with title
        body:
            const VoiceRecorderExample(), // Main screen with the voice recorder & player widgets
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
  File? recordedFile; // Variable to hold the recorded audio file locally

  String recordedAudioBlobUrl =
      ""; // Variable to hold the recorded audio blob URL

  late final VoiceNotePlayerController playerController;

  @override
  void initState() {
    playerController = VoiceNotePlayerController();
    super.initState();
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            VoiceRecorderBar(
              onRecorded: (file) {
                recordedFile = file;
                setState(() {});
              },
            ),

            AudioPlayerWidget(
              autoPlay:
                  false, // Whether to automatically start playback when the widget builds
              autoLoad:
                  true, // Whether to preload the audio before the user presses play
              audioPath:
                  "https://commondatastorage.googleapis.com/codeskulptor-demos/riceracer_assets/fx/engine-10.ogg", // The path or URL of the audio file
              audioType: AudioType
                  .url, // Specifies if the audio is from a URL, asset, or file
              playerStyle: PlayerStyle
                  .style1, // The visual style of the player (you can choose between different predefined styles)
              textDirection:
                  TextDirection.rtl, // Text direction for RTL or LTR languages
              size: 60, // Size of the play/pause button
              progressBarHeight: 5, // Height of the progress bar
              backgroundColor: Colors.blue, // Background color of the widget
              progressBarColor:
                  Colors.blue, // Color of the progress bar (played portion)
              progressBarBackgroundColor:
                  Colors.white, // Background color of the progress bar
              iconColor: Colors.white, // Color of the play/pause icon
              shapeType: PlayIconShapeType
                  .circular, // Shape of the play/pause button (e.g., circular or square)
              showProgressBar: true, // Whether to show the progress bar
              showTimer: true, // Whether to display the current time/duration
              width: 300, // Width of the whole audio player widget
              audioSpeeds: const [
                0.5,
                1.0,
                1.5,
                2.0,
                3.0
              ], // Supported audio playback speeds
              onSeek: (value) => print(
                  'Seeked to: $value'), // Callback when user seeks to a new position
              onError: (message) =>
                  print('Error: $message'), // Callback when an error occurs
              onPause: () => print("Paused"), // Callback when audio is paused
              onPlay: (isPlaying) => print(
                  "Playing: $isPlaying"), // Callback when audio starts or resumes playing
              onSpeedChange: (speed) => print(
                  "Speed: $speed"), // Callback when playback speed is changed
            ),

            const SizedBox(height: 30),

            // ------------------------ Asset Audio Example (Style 5) ------------------------
            const AudioPlayerWidget(
              autoLoad: true,
              audioPath:
                  "assets/start_warning.mp3", // Path to an asset audio file
              audioType:
                  AudioType.assets, // Specify that the audio source is an asset
              textDirection:
                  TextDirection.ltr, // Set the text direction (Left to Right)
              size: 60, // Size of the player widget
              progressBarHeight: 5, // Height of the progress bar
              backgroundColor:
                  Color(0xff25D366), // Background color of the player
              progressBarColor: Color(0xff25D366), // Color of the progress bar
              progressBarBackgroundColor:
                  Colors.white, // Background color of the progress bar
              iconColor: Colors.white, // Color of the play/pause icon
              shapeType: PlayIconShapeType
                  .circular, // Shape type for the play/pause icon
              playerStyle: PlayerStyle.style5, // Player style for the widget
              width: 300, // Width of the player widget
              showProgressBar: true, // Show the progress bar
              showTimer: true, // Show the timer
            ),

            const SizedBox(height: 30),

            // ------------------------ Recorded Audio (Style 1) ------------------------
            recordedFile != null
                ? AudioPlayerWidget(
                    autoLoad: true,
                    audioPath:
                        recordedFile?.path, // Path to the recorded audio file
                    size: 60, // Size of the player widget
                    progressBarHeight: 7, // Height of the progress bar
                    backgroundColor:
                        Colors.blueAccent, // Background color of the player
                    progressBarColor: Colors.blue, // Color of the progress bar
                    progressBarBackgroundColor:
                        Colors.white, // Background color of the progress bar
                    iconColor: Colors.white, // Color of the play/pause icon
                    shapeType: PlayIconShapeType
                        .circular, // Shape type for the play/pause icon
                    playerStyle:
                        PlayerStyle.style1, // Player style for the widget
                    textDirection: TextDirection
                        .rtl, // Set the text direction (Right to Left)
                    width: 300, // Width of the player widget
                    showProgressBar: true, // Show the progress bar
                    showTimer: true, // Show the timer
                  )
                : const SizedBox
                    .shrink(), // If no file is recorded, show an empty space

            const SizedBox(height: 30),

            // ------------------------ Asset Audio (Style 4) ------------------------
            const AudioPlayerWidget(
              autoLoad: true,
              audioPath:
                  "assets/start_warning.mp3", // Path to an asset audio file
              audioType:
                  AudioType.assets, // Specify that the audio source is an asset
              size: 30, // Size of the player widget
              progressBarHeight: 5, // Height of the progress bar
              backgroundColor: Colors.blue, // Background color of the player
              progressBarColor: Color.fromARGB(
                  255, 62, 167, 252), // Color of the progress bar
              progressBarBackgroundColor:
                  Colors.white, // Background color of the progress bar
              iconColor: Colors.white, // Color of the play/pause icon
              shapeType: PlayIconShapeType
                  .circular, // Shape type for the play/pause icon
              playerStyle: PlayerStyle.style4, // Player style for the widget
              width: 300, // Width of the player widget
              showProgressBar: true, // Show the progress bar
              showTimer: true, // Show the timer
            ),

            const SizedBox(height: 30),

            // ------------------------ Recorded Audio (Style 2) ------------------------
            recordedFile != null
                ? Column(
                    children: [
                      AudioPlayerWidget(
                        controller: playerController,
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
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        alignment: WrapAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => playerController.play(),
                            child: const Text('Play'),
                          ),
                          ElevatedButton(
                            onPressed: () => playerController.pause(),
                            child: const Text('Pause'),
                          ),
                          ElevatedButton(
                            onPressed: () => playerController
                                .setSpeed(1.5), // Set speed to 1.5x(),
                            child: const Text('Speed x1.5'),
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                playerController.seekTo(0.2), // Seek to 20%
                            child: const Text('Seek to 20%'),
                          ),
                        ],
                      ),
                    ],
                  )
                : const SizedBox.shrink(),

            const SizedBox(height: 30),

            // ------------------------ Recorded Audio (Style 3) ------------------------
            recordedFile != null
                ? AudioPlayerWidget(
                    autoLoad: true,
                    audioPath:
                        recordedFile?.path, // Path to the recorded audio file
                    size: 60, // Size of the player widget
                    progressBarHeight: 5, // Height of the progress bar
                    backgroundColor:
                        Colors.blueAccent, // Background color of the player
                    progressBarColor: Colors.blue, // Color of the progress bar
                    progressBarBackgroundColor:
                        Colors.white, // Background color of the progress bar
                    iconColor: Colors.white, // Color of the play/pause icon
                    shapeType: PlayIconShapeType
                        .circular, // Shape type for the play/pause icon
                    playerStyle:
                        PlayerStyle.style3, // Player style for the widget
                    width: 300, // Width of the player widget
                    showProgressBar: true, // Show the progress bar
                    showTimer: true, // Show the timer
                  )
                : const SizedBox
                    .shrink(), // If no file is recorded, show an empty space

            const SizedBox(height: 30),
            // ------------------------ URL Audio Playback Example FOR WEB ONLY ------------------------
            recordedAudioBlobUrl.isNotEmpty
                ? AudioPlayerWidget(
                    autoPlay: false, // Don't auto-play the audio

                    autoLoad:
                        true, // Automatically load the audio when the widget is created
                    audioPath: recordedAudioBlobUrl, // URL of the audio to play
                    /////============================= Flutter WEB ONly =================================
                    audioType: AudioType
                        .blobforWeb, // Specify that the audio source is a URL

                    /////============================= Style 5 is Not Suppoted for WEB =================================
                    playerStyle:
                        PlayerStyle.style1, // Player style for the widget
                    textDirection: TextDirection
                        .rtl, // Set the text direction (Right to Left)
                    size: 60, // Size of the player widget
                    progressBarHeight: 5, // Height of the progress bar
                    backgroundColor:
                        Colors.blueAccent, // Background color of the player
                    progressBarColor: Colors.blue, // Color of the progress bar
                    progressBarBackgroundColor:
                        Colors.white, // Background color of the progress bar
                    iconColor: Colors.white, // Color of the play/pause icon
                    shapeType: PlayIconShapeType
                        .circular, // Shape type for the play/pause icon
                    showProgressBar: true, // Show the progress bar
                    showTimer: true, // Show the timer
                    width: 300, // Width of the player widget
                    audioSpeeds: const [
                      0.5,
                      1.0,
                      1.5,
                      2.0,
                      3.0
                    ], // Supported audio speeds
                    onSeek: (value) =>
                        print('Seeked to: $value'), // Log the seeked position
                    onError: (message) =>
                        print('Error: $message'), // Log any errors
                    onPause: () => print("Paused"), // Log pause action
                    onPlay: (isPlaying) =>
                        print("Playing: $isPlaying"), // Log play action
                    onSpeedChange: (speed) =>
                        print("Speed: $speed"), // Log speed change
                  )
                : const SizedBox.shrink(),

            // ----------------------------------------------------------------

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
