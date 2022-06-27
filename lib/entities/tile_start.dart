import 'dart:ui';

import 'package:trail/entities/tile.dart';

import '../utils/resources.dart';

class TileStart extends Tile{
  TileStart():super(0, 0);

  @override
  void draw(Canvas canvas, Paint paint) {
    canvas.drawCircle(
        const Offset(0, -2*Resources.scale), Resources.scale, paint);
  }
}