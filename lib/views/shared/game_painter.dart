import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../../entities/tile.dart';
import '../../utils/resources.dart';

class GamePainter extends CustomPainter{
  
  List<Tile> tiles;
  
  GamePainter({
    required this.tiles
  });

  static final customPaint = Paint()
    ..color = Resources.primary
    ..strokeWidth = 24
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
  
  @override
  void paint(Canvas canvas, Size size) {

    canvas.translate(size.width/2, size.height/2-2*Resources.scale);
    canvas.rotate(pi);

    for (var tile in tiles) { 
      tile.draw(canvas, customPaint); 
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}