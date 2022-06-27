import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:trail/entities/tile_cross.dart';
import 'package:trail/entities/tile_line.dart';
import 'package:trail/utils/game_data.dart';

import '../entities/option.dart';
import '../entities/tile.dart';
import '../entities/tile_left.dart';
import '../entities/tile_right.dart';
import '../entities/tile_start.dart';

enum GameStatus { fail, game, complete }

class GameModel extends ChangeNotifier {

  int r = 0; int dr = 0;
  late int steps;
  int x = 0; int dx = 0;
  int y = 0; int dy = 0;

  int level = 0;

  List<Tile> list = [TileStart()];
  List<Option> buttons = [];
  String? message;

  List<TileType> solution = [];
  int? highlight;

  GameStatus status = GameStatus.game;

  Function? _completeCallback;
  set completeCallback(Function f){
    _completeCallback = f;
  }

  Function? _failCallback;
  set failCallback(Function f){
    _failCallback = f;
  }

  void initLevel(int level) async {
    this.level = level;
    GameData.saveLevel(level);
    list = [TileStart()];
    buttons = GameData.loadLevel(this.level);
    message = GameData.loadMessage(this.level);
    x = 0; dx = 0;
    y = 0; dy = 0;

    steps = 0;
    for(Option opt in buttons) {
      steps += opt.number;
    }
    await Future.delayed(const Duration(seconds: 1));
    status = GameStatus.game;
    r = 0; dr = 0;
  }

  void choose(TileType type) {
    dx = 0; dy = 0; dr = 0;

    steps--;

    makeStep(type: type);
    addTile(type);
    check();

    if(steps == 0 && status != GameStatus.complete){
      restart();
    }
    x += dx;
    y += dy;

    if(highlight != null) showNextStep();

    notifyListeners();
  }

  void check(){
    int cx = x + dx - cos((r + 1) * pi / 2).toInt();
    int cy = y + dy + sin((r + 1) * pi / 2).toInt();
    if(cx == 0 && cy == 0) {
      if(steps == 0){
        complete();
      } else {
        restart();
      }
      return;
    }
    for (int i = 0; i < list.length-1; i++) {
      if(list[i].x == cx && list[i].y == cy){
        if(list[i] is TileCross) {
          makeStep();
          list.add(TileCross(x + dx, y + dy, visible: false));
          check();
        } else {
          restart();
        }
        break;
      }
    }
  }

  void addTile(TileType type) {
    Tile? tile;
    int cx = x + dx;
    int cy = y + dy;
    switch (type) {
      case TileType.line:
        tile = TileLine(cx, cy);
        break;
      case TileType.right:
        tile = TileRight(cx, cy);
        break;
      case TileType.left:
        tile = TileLeft(cx, cy);
        break;
      case TileType.cross:
        tile = TileCross(cx, cy);
        break;
      default:
        break;
    }
    if (tile != null) {
      list.add(tile);
    }
  }

  void makeStep({TileType? type}){
    dx -= cos((r + 1) * pi / 2).toInt();
    dy += sin((r + 1) * pi / 2).toInt();
    if(type != null) {
      if (type == TileType.right) {
        dr = -1;
      } else if (type == TileType.left) {
        dr = 1;
      }
      r += dr;
      if(r == 2) r = 0;
    }
  }

  void restart() async {
    status = GameStatus.fail;
    if(list.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 500));
      dx = -x;
      dy = -y;
      dr = r == 0 ? 0 : -r;
      x = 0;
      y = 0;
      r = 0;
      notifyListeners();
    }
    if (_failCallback != null){
      _failCallback!();
    }
  }

  void complete() async {
    status = GameStatus.complete;
    await Future.delayed(const Duration(milliseconds: 500));
    dx = 0; dy = 0; dr = 0;
    makeStep();
    x += dx;
    y += dy;
    notifyListeners();
    if (_completeCallback != null){
      _completeCallback!();
    }
  }

  void showNextStep(){
    if(highlight == null) {
      highlight = 0;
    } else {
      highlight = highlight! + 1;
    }
    if(highlight! < solution.length) {
      for (Option opt in buttons) {
        opt.active = opt.type == solution[highlight!];
      }
    }
  }

  void getSolution() {
    solution = GameData.loadSolution(level);
    restart();
  }

  void discardSolution(){
    solution = [];
    highlight = null;
  }
}
