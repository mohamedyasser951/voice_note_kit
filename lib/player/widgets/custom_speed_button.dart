import 'package:flutter/material.dart';

class SpeedButton extends StatelessWidget {
  final double currentSpeed;
  final List<double> playbackSpeeds;
  final Function(double speed) setSpeed;
  final Color iconColor;
  final Color? backgroundColor;

  const SpeedButton({
    super.key,
    required this.currentSpeed,
    required this.playbackSpeeds,
    required this.setSpeed,
    required this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        int currentIndex = playbackSpeeds.indexOf(currentSpeed);
        int nextIndex = (currentIndex + 1) % playbackSpeeds.length;
        double nextSpeed = playbackSpeeds[nextIndex];
        setSpeed(nextSpeed);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: backgroundColor ?? iconColor.withOpacity(0.2),
        ),
        child: Text(
          '${currentSpeed}x',
          style: TextStyle(color: iconColor, fontSize: 14),
        ),
      ),
    );
  }
}
