import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import 'package:voice_note_kit/player/utils/format_duration.dart';
import 'package:voice_note_kit/recorder/utils/utils_for_mobile.dart';
import 'package:voice_note_kit/recorder/utils/utils_for_web.dart';
import 'audio_recorder.dart';
import 'sound_player.dart';

class VoiceRecorderBar extends StatefulWidget {
  final Function(File file)? onRecorded;
  final Function(String url)? onRecordedWeb;
  final Function(String error)? onError;
  final Function()? onStartRecording;
  final Function()? onStopRecording;
  final String? startSoundAsset;
  final String? stopSoundAsset;
  final bool enableHapticFeedback;
  final Duration? maxRecordDuration;

  const VoiceRecorderBar({
    super.key,
    this.onRecorded,
    this.onRecordedWeb,
    this.onError,
    this.onStartRecording,
    this.onStopRecording,
    this.startSoundAsset,
    this.stopSoundAsset,
    this.enableHapticFeedback = true,
    this.maxRecordDuration,
  });

  @override
  State<VoiceRecorderBar> createState() => _VoiceRecorderBarState();
}

class _VoiceRecorderBarState extends State<VoiceRecorderBar> {
  final _recorder = AudioRecorderClass();
  bool _isRecording = false;
  String? _filePath;
  Timer? _timer;
  int _seconds = 0;

  @override
  void dispose() {
    _recorder.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      final hasPermission = await _checkPermissions();
      if (!hasPermission) {
        widget.onError?.call('Permission not granted');
        return;
      }

      widget.onStartRecording?.call();

      if (widget.enableHapticFeedback) {
        HapticFeedback.mediumImpact();
      }

      if (kIsWeb) {
        _filePath = getTempFileForWeb();
      } else {
        _filePath = await getTempFilePath();
      }

      if (widget.startSoundAsset != null) {
        await playSound(widget.startSoundAsset!);
      }

      await _recorder.start(const RecordConfig(), path: _filePath!);
      _startTimer();

      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      widget.onError?.call(e.toString());
    }
  }

  Future<void> _stopRecording() async {
    try {
      _timer?.cancel();

      if (widget.stopSoundAsset != null) {
        await playSound(widget.stopSoundAsset!);
      }

      String filePath = await _recorder.stop();
      widget.onStopRecording?.call();

      setState(() {
        _isRecording = false;
      });

      if (_filePath != null && widget.onRecorded != null) {
        if (kIsWeb) {
          widget.onRecordedWeb?.call(filePath);
        } else {
          widget.onRecorded?.call(File(_filePath!));
        }
      }
    } catch (e) {
      widget.onError?.call(e.toString());
    }
  }

  void _startTimer() {
    _seconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _seconds++);
      if (widget.maxRecordDuration != null &&
          _seconds >= widget.maxRecordDuration!.inSeconds) {
        _stopRecording();
      }
    });
  }

  Future<bool> _checkPermissions() async {
    if (Platform.isMacOS) return true;
    final mic = await Permission.microphone.request();
    return mic == PermissionStatus.granted;
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FB),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left side - Recording button
            GestureDetector(
              onTap: _isRecording ? _stopRecording : _startRecording,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: _isRecording ? Colors.red : const Color(0xFF1A3353),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color:
                          (_isRecording ? Colors.red : const Color(0xFF1A3353))
                              .withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                width: 36,
                height: 36,
                child: Icon(
                  _isRecording ? Icons.stop : Icons.mic,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Text or Wave animation
            if (!_isRecording)
              const Text(
                'تسجيل ريكورد',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1A3353),
                ),
              )
            else
              Expanded(
                child: _WaveBars(),
              ),
            const SizedBox(width: 12),
            // Right side - Timer
            if (_isRecording)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A3353).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  formatDurationSeconds(_seconds),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1A3353),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      );
  }
}

// Simple animated wave bars for demo
class _WaveBars extends StatefulWidget {
  @override
  State<_WaveBars> createState() => _WaveBarsState();
}

class _WaveBarsState extends State<_WaveBars>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _barAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _barAnimations = List.generate(15, (i) {
      final start = i * 0.05;
      final end = start + 0.05;
      return Tween<double>(begin: 4, end: 24).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeInOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_barAnimations.length, (i) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                width: 2.5,
                height: _barAnimations[i].value,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A3353).withValues(alpha: .8),
                  borderRadius: BorderRadius.circular(1.25),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
