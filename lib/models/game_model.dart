import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:trail/entities/tile_cross.dart';
import 'package:trail/entities/tile_line.dart';
import 'package:trail/repository/game_data.dart';

import '../entities/option.dart';
import '../entities/tile.dart';
import '../entities/tile_left.dart';
import '../entities/tile_right.dart';
import '../entities/tile_start.dart';

enum GameStatus { fail, game, complete }

class GameModel extends ChangeNotifier {
  int r = 0;
  int dr = 0;
  late int steps;
  int x = 0;
  int dx = 0;
  int y = 0;
  int dy = 0;

  int level = -1;

  List<Tile> list = [];
  List<Option> buttons = [];
  String? message;

  List<TileType> solution = [];
  int? highlight;

  GameStatus status = GameStatus.game;

  Function(int)? _setLevelCallback;

  set setLevelCallback(Function(int) f) {
    _setLevelCallback = f;
  }

  Function? _restartCallback;

  set restartCallback(Function f) {
    _restartCallback = f;
  }

  void initLevel(int level) async {
    x = 0;
    y = 0;
    dx = 0;
    dy = 0;
    if(level == this.level){
      r = 0;
      dr = 0;
    } else {
      GameData.saveLevel(level);
      this.level = level;
      message = GameData.loadMessage(this.level);
    }
    list = [TileStart()];
    buttons = GameData.loadButtons(this.level);
    steps = 0;
    for (Option opt in buttons) {
      steps += opt.number;
    }
    await Future.delayed(const Duration(seconds: 1));
    status = GameStatus.game;
    r = 0;
    dr = 0;
    notifyListeners();
  }

  void choose(TileType type) {
    dx = 0;
    dy = 0;
    dr = 0;

    steps--;

    makeStep(type: type);
    addTile(type);
    check();

    if (steps == 0 && status != GameStatus.complete && status != GameStatus.fail) {
      restart();
    }
    x += dx;
    y += dy;

    if (highlight != null) showNextStep();

    notifyListeners();
  }

  void check() {
    int cx = x + dx - cos((r + 1) * pi / 2).toInt();
    int cy = y + dy + sin((r + 1) * pi / 2).toInt();
    if (cx == 0 && cy == 0) {
      if (steps == 0) {
        complete();
      } else {
        restart();
      }
      return;
    }
    for (int i = 1; i < list.length - 1; i++) {
      if (list[i].x == cx && list[i].y == cy) {
        if (list[i] is TileCross) {
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

  void makeStep({TileType? type}) {
    dx -= cos((r + 1) * pi / 2).toInt();
    dy += sin((r + 1) * pi / 2).toInt();
    if (type != null) {
      if (type == TileType.right) {
        dr = -1;
      } else if (type == TileType.left) {
        dr = 1;
      }
      r = (r + dr) % 4;
    }
  }

  void restart() async {
    status = GameStatus.fail;
    if (list.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 500));
      dx = -x;
      dy = -y;
      dr = -r;
      x = 0;
      y = 0;
      r = 0;
      notifyListeners();
    }
    if (_restartCallback != null) {
      _restartCallback!();
    }
  }

  void complete() async {
    status = GameStatus.complete;
    await Future.delayed(const Duration(milliseconds: 500));
    dx = 0;
    dy = 0;
    dr = 0;
    makeStep();
    x += dx;
    y += dy;
    notifyListeners();
    startLevel(level+1);
  }

  void startLevel(int level) {
    if (_setLevelCallback != null) {
      _setLevelCallback!(level);
    }
  }

  void showNextStep() {
    if (highlight == null) {
      highlight = 0;
    } else {
      highlight = highlight! + 1;
    }
    if (highlight! < solution.length) {
      for (Option opt in buttons) {
        opt.active = opt.type == solution[highlight!];
      }
    }
  }

  void getSolution() {
    solution = GameData.loadSolution(level);
    restart();
  }

  void discardSolution() {
    solution = [];
    highlight = null;
  }
}
