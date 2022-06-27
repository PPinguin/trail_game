import 'dart:math';
import 'dart:ui';

import 'package:trail/entities/tile.dart';

import '../utils/resources.dart';

class TileLeft extends Tile{
  TileLeft(int x, int y):super(x,y);

  @override
  void draw(Canvas canvas, Paint paint) {
    canvas.drawArc(
        const Offset(0, -2*Resources.scale) &
        const Size(Resources.scale*2, Resources.scale*2),
        pi, -pi / 2,
        false,
        paint);
    transform(canvas, 1, 0, -1);
  }
  
}