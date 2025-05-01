import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget {
  final double progress;
  final Color progressBarColor;
  final Color progressBarBackgroundColor;
  final Function(double value) seekTo;

  const CustomSlider({
    super.key,
    required this.progress,
    required this.progressBarColor,
    required this.progressBarBackgroundColor,
    required this.seekTo,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: progressBarColor,
          inactiveTrackColor: progressBarBackgroundColor,
          thumbColor: progressBarColor,
          trackHeight: 6,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          overlayShape: SliderComponentShape.noOverlay, // Removes overlay glow
          trackShape: const _CustomTrackShape(), // Removes side padding
        ),
        child: Slider(
          value: progress,
          onChanged: seekTo,
        ),
      ),
    );
  }
}

class _CustomTrackShape extends RoundedRectSliderTrackShape {
  const _CustomTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 6;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
