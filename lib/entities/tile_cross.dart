import 'dart:ui';

import 'package:trail/entities/tile.dart';

import '../utils/resources.dart';

class TileCross extends Tile{
  final bool visible;
  TileCross(int x, int y, {this.visible = true}):super(x,y);

  @override
  void draw(Canvas canvas, Paint paint) {
    if(!visible){
      transform(canvas, 0, 1, 0);
      return;
    }
    canvas.drawLine(const Offset(0, -Resources.scale),
        const Offset(0, Resources.scale), paint);
    canvas.drawLine(const Offset(-Resources.scale, 0),
        const Offset(Resources.scale, 0), paint);
    transform(canvas, 0, 1, 0);
  }

}