import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double progressBarHeight;
  final Color progressBarBackgroundColor;
  final Color progressBarColor;
  final double progress;
  final Function(double) seekTo;

  const ProgressBar({
    super.key,
    required this.progressBarHeight,
    required this.progressBarBackgroundColor,
    required this.progressBarColor,
    required this.progress,
    required this.seekTo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        double newProgress =
            (progress + details.primaryDelta! / context.size!.width)
                .clamp(0.0, 1.0);
        seekTo(newProgress);
      },
      onHorizontalDragEnd: (details) {
        seekTo(progress);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: progressBarHeight,
        color: progressBarBackgroundColor,
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(progressBarColor),
        ),
      ),
    );
  }
}
