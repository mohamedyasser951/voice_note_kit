import 'package:flutter/material.dart';
import 'package:voice_note_kit/player/player_enums/player_enums.dart';

ShapeBorder getShape(PlayIconShapeType shapeType) {
  switch (shapeType) {
    case PlayIconShapeType.roundedRectangle:
      return RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
    case PlayIconShapeType.square:
      return const RoundedRectangleBorder();
    case PlayIconShapeType.circular:
    default:
      return const CircleBorder();
  }
}
