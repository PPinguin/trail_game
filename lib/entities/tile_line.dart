import 'dart:ui';

import 'package:trail/entities/tile.dart';
import 'package:trail/utils/resources.dart';

class TileLine extends Tile{
  TileLine(int x, int y):super(x,y);

  @override
  void draw(Canvas canvas, Paint paint) {
    canvas.drawLine(const Offset(0, -Resources.scale),
        const Offset(0, Resources.scale), paint);
    transform(canvas, 0, 1, 0);
  }
  
}