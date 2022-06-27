import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:trail/views/shared/game_painter.dart';

import '../../utils/resources.dart';

class SplashPainter extends CustomPainter{

  final double progress;

  SplashPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width/2, size.height/2);
    canvas.rotate(-pi/2);
    canvas.drawArc(
        const Offset(-Resources.scale, -Resources.scale) &
        const Size(Resources.scale*2, Resources.scale*2),
        0, progress, false, GamePainter.customPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}