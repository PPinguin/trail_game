import 'package:trail/entities/tile.dart';

class Option{
  TileType type;
  int number = 0;
  bool active = true;

  Option(this.type, this.number);
}