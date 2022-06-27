import 'dart:math';
import 'dart:ui';

import 'package:trail/entities/tile.dart';

import '../utils/resources.dart';

class TileRight extends Tile{
  TileRight(int x, int y):super(x,y);

  @override
  void draw(Canvas canvas, Paint paint) {
    canvas.drawArc(
        const Offset(-2*Resources.scale, -2*Resources.scale) &
        const Size(Resources.scale*2, Resources.scale*2),
        0, pi / 2,
        false,
        paint);
    transform(canvas, -1, 0, 1);
  }

}