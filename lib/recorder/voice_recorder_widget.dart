import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voice_note_kit/player/utils/format_duration.dart';
import 'audio_recorder.dart';
import 'sound_player.dart';

class VoiceRecorderWidget extends StatefulWidget {
  final Function(File file)? onRecorded;
  final Function(String error)? onError;
  final Function()? onStartRecording;
  final Function()? actionWhenCancel;
  final Function()? onMaxDurationReached;

  final Widget? startRecordingWidget;
  final Widget? stopRecordingWidget;

  final String permissionNotGrantedMessage;
  final String recordCancelledMessage;
  final String cancelDoneText;
  final String dragToLeftText;

  final double iconSize;
  final TextStyle? timerTextStyle;
  final TextStyle? dragToLeftTextStyle;

  final double timerFontSize;
  final Color backgroundColor;
  final Color cancelHintColor;
  final Color iconColor;

  final bool showSwipeLeftToCancel;
  final bool showTimerText;

  final bool enableHapticFeedback;

  final Duration? maxRecordDuration;

  final String? startSoundAsset;
  final String? stopSoundAsset;

  const VoiceRecorderWidget({
    super.key,
    required this.onRecorded,
    this.onError,
    this.onStartRecording,
    this.actionWhenCancel,
    this.onMaxDurationReached,
    this.startRecordingWidget,
    this.stopRecordingWidget,
    this.maxRecordDuration,
    this.timerFontSize = 16,
    this.showSwipeLeftToCancel = true,
    this.showTimerText = true,
    this.enableHapticFeedback = true,
    this.backgroundColor = Colors.blueAccent,
    this.cancelHintColor = Colors.redAccent,
    this.iconColor = Colors.white,
    this.timerTextStyle,
    this.dragToLeftTextStyle,
    this.cancelDoneText = 'Cancel Done',
    this.permissionNotGrantedMessage = 'Permission not granted',
    this.recordCancelledMessage = 'Record cancelled',
    this.dragToLeftText = '← Drag to left to cancel',
    this.iconSize = 56,
    this.startSoundAsset,
    this.stopSoundAsset,
  });

  @override
  State<VoiceRecorderWidget> createState() => _VoiceRecorderWidgetState();
}

class _VoiceRecorderWidgetState extends State<VoiceRecorderWidget> {
  final _recorder = AudioRecorderClass();
  bool _isRecording = false;
  bool _isCancelled = false;
  String? _filePath;
  double dragDistance = 0.0;
  Offset? _startOffset;
  Timer? _timer;
  int _seconds = 0;
  Color _backgroundColor = Colors.blueAccent;
  bool _showCancelHint = false;

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
        widget.onError!(widget.permissionNotGrantedMessage);
        return;
      }

      widget.onStartRecording?.call();

      if (widget.enableHapticFeedback) {
        HapticFeedback.mediumImpact();
      }

      final dir = await getTemporaryDirectory();
      _filePath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';

      if (widget.startSoundAsset != null) {
        _playAssetSound(widget.startSoundAsset!);
      }

      await _recorder.start(const RecordConfig(), path: _filePath!);
      _startTimer();

      setState(() {
        _isRecording = true;
        _isCancelled = false;
        dragDistance = 0;
        _backgroundColor = widget.cancelHintColor;
        _showCancelHint = true;
      });
    } catch (e) {
      widget.onError?.call(e.toString());
    }
  }

  Future<void> _stopRecording() async {
    try {
      _timer?.cancel();

      if (widget.stopSoundAsset != null) {
        _playAssetSound(widget.stopSoundAsset!);
      }

      await _recorder.stop();

      setState(() {
        _isRecording = false;
      });

      if (!_isCancelled && _filePath != null && widget.onRecorded != null) {
        widget.onRecorded!(File(_filePath!));
      }
    } catch (e) {
      widget.onError?.call(e.toString());
    }
  }

  void _cancelRecording() {
    try {
      _isCancelled = true;
      _timer?.cancel();
      _recorder.stop();
      if (widget.enableHapticFeedback) {
        HapticFeedback.mediumImpact();
      }
      setState(() {
        _isRecording = false;
        _backgroundColor = widget.backgroundColor;
        _showCancelHint = false;
      });
      if (widget.actionWhenCancel != null) {
        widget.actionWhenCancel!();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.recordCancelledMessage)),
        );
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
        widget.onMaxDurationReached?.call();
      }
    });
  }

  Future<bool> _checkPermissions() async {
    final mic = await Permission.microphone.request();
    return mic == PermissionStatus.granted;
  }

  Future<void> _playAssetSound(String assetPath) async {
    try {
      await playSound(assetPath);
    } catch (e) {
      widget.onError?.call(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        _startOffset = details.globalPosition;
        _startRecording();
        setState(() {
          _showCancelHint = true;
        });
      },
      onLongPressMoveUpdate: (details) {
        if (widget.showSwipeLeftToCancel &&
            _isRecording &&
            _startOffset != null) {
          double distance = details.globalPosition.dx - _startOffset!.dx;

          setState(() {
            dragDistance = distance;
            double percent = (distance.abs() / 100).clamp(0, 1);
            _backgroundColor = Color.lerp(
                widget.cancelHintColor, widget.backgroundColor, 1 - percent)!;
          });

          if (distance < -70 && !_isCancelled) {
            _cancelRecording();
          }
        }
      },
      onLongPressEnd: (_) {
        if (!_isCancelled) {
          _stopRecording();
        }
        setState(() {
          _showCancelHint = false;
          _backgroundColor = widget.backgroundColor;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isRecording && _showCancelHint && widget.showSwipeLeftToCancel)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                widget.dragToLeftText,
                style: widget.dragToLeftTextStyle ??
                    const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          if (_isRecording && widget.showTimerText)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                _isCancelled
                    ? widget.cancelDoneText
                    : formatDurationSeconds(_seconds),
                style: widget.timerTextStyle ??
                    TextStyle(
                      color: widget.cancelHintColor,
                      fontSize: widget.timerFontSize,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.iconSize,
            height: widget.iconSize,
            decoration: BoxDecoration(
              color: _isRecording ? _backgroundColor : widget.backgroundColor,
              shape: BoxShape.circle,
              boxShadow: _isRecording
                  ? [
                      BoxShadow(
                          color: widget.cancelHintColor.withOpacity(0.4),
                          blurRadius: 8)
                    ]
                  : [],
            ),
            child: _isRecording && widget.stopRecordingWidget != null
                ? widget.stopRecordingWidget
                : !_isRecording && widget.startRecordingWidget != null
                    ? widget.startRecordingWidget
                    : Icon(
                        _isRecording ? Icons.stop : Icons.mic_none,
                        color: widget.iconColor,
                        size: widget.iconSize / 2.3,
                      ),
          ),
        ],
      ),
    );
  }
}
