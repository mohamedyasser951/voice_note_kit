import 'package:flutter/material.dart';
import 'package:voice_note_kit/player/player_enums/player_enums.dart';
import 'package:voice_note_kit/player/utils/get_shape.dart';

class PlayerControls extends StatelessWidget {
  final double size;
  final Color iconColor;
  final Color backgroundColor;
  final PlayIconShapeType shapeType;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final TextDirection textDirection;

  const PlayerControls({
    super.key,
    required this.size,
    required this.iconColor,
    required this.backgroundColor,
    required this.shapeType,
    required this.isPlaying,
    required this.onPlayPause,
    required this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: size,
      height: size,
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: getShape(shapeType),
      ),
      child: IconButton(
        icon: RotatedBox(
          quarterTurns: textDirection == TextDirection.ltr ? 0 : 2,
          child: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: iconColor,
            size: size / 2.3,
          ),
        ),
        onPressed: onPlayPause,
      ),
    );
  }
}
