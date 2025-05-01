import 'package:flutter/material.dart';

class WaveformSlider extends StatelessWidget {
  final List<double> waveform;
  final double progress; // from 0.0 to 1.0
  final Color activeColor;
  final Color inactiveColor;
  final Function(double) onSeek;

  final TextDirection textDirection;

  const WaveformSlider(
      {super.key,
      required this.waveform,
      required this.progress,
      required this.activeColor,
      required this.inactiveColor,
      required this.onSeek,
      this.textDirection = TextDirection.ltr});

  void _handleSeek(BuildContext context, Offset globalPosition) {
    final box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(globalPosition);
    final width = box.size.width;

    double newProgress = localPosition.dx.clamp(0.0, width) / width;

    // Reverse progress for RTL layout
    if (textDirection == TextDirection.rtl) {
      newProgress = 1.0 - newProgress;
    }

    onSeek(newProgress);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) => _handleSeek(context, details.globalPosition),
      onHorizontalDragStart: (details) =>
          _handleSeek(context, details.globalPosition),
      onHorizontalDragUpdate: (details) =>
          _handleSeek(context, details.globalPosition),
      child: CustomPaint(
        size: const Size(double.infinity, 40),
        painter: _WaveformPainter(
          waveform: waveform,
          progress: progress,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          isRtl: textDirection == TextDirection.rtl ? true : false,
        ),
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final List<double> waveform;
  final double progress;
  final Color activeColor;
  final Color inactiveColor;
  final bool isRtl;

  _WaveformPainter({
    required this.waveform,
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
    required this.isRtl,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.butt;

    const barSpacing = 1.0;
    const barWidth = 2.0;
    final totalBars = (size.width / (barWidth + barSpacing)).floor();

    for (int i = 0; i < totalBars; i++) {
      final index = (i / totalBars * waveform.length).floor();
      final heightFactor = waveform[index.clamp(0, waveform.length - 1)];
      final barHeight = heightFactor * size.height;

      final x = i * (barWidth + barSpacing);
      final effectiveX = isRtl ? size.width - x : x;

      final normalizedProgressX =
          isRtl ? (1.0 - (effectiveX / size.width)) : (effectiveX / size.width);

      paint.color =
          normalizedProgressX <= progress ? activeColor : inactiveColor;

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(effectiveX, size.height / 2),
          width: barWidth,
          height: barHeight,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.waveform != waveform ||
        oldDelegate.isRtl != isRtl;
  }
}
