import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../utils/resources.dart';

abstract class Tile {

  int x = 0;
  int y = 0;

  Tile(this.x, this.y);

  void draw(Canvas canvas, Paint paint);
   
  void transform(Canvas canvas, int dx, int dy, int dr){
    canvas.translate(2*dx*Resources.scale, 2*dy*Resources.scale);
    canvas.rotate(dr*pi/2);
  }
}

enum TileType { start, line, right, left, cross }
