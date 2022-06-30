import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:trail/entities/tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/option.dart';

class GameData {
  static late SharedPreferences _prefs;
  static List<dynamic> _levels = [];
  static bool sounds = true;

  static int get size {
    return _levels.length;
  }

  static int get max{
    return _prefs.getInt('max') ?? 0;
  }

  static int get level{
    return _prefs.getInt('level') ?? 0;
  }

  static Future<void> initialize() async {
    if(_levels.isEmpty) {
      String source = await rootBundle.loadString('assets/levels/levels.json');
      _levels = jsonDecode(source);
    }
    _prefs = await SharedPreferences.getInstance();
    sounds = _prefs.getBool('sounds') ?? true;
  }

  static void saveLevel(int level) async {
    if((_prefs.getInt('max') ?? 0) < level) {
      await _prefs.setInt('max', level);
    }
    await _prefs.setInt('level', level);
  }

  static void saveSounds(bool value) async {
    await _prefs.setBool('sounds', value);
    sounds = value;
  }

  static String? loadMessage(int level){
    if((_levels[level] as Map<String, dynamic>).containsKey('message')){
      return _levels[level]['message'];
    } else {
      return null;
    }
  }

  static List<TileType> loadSolution(int level){
    List<TileType> result = [];
    for(String type in (_levels[level]["path"] as String).split('')){
      TileType? t = _parse(type);
      if(t != null) result.add(t);
    }
    return result;
  }

  static List<Option> loadButtons(int level){
    List<Option> result = [];
    if((_levels[level] as Map<String, dynamic>).containsKey('path')) {
      Map<TileType, int> cache = {};
      for (String type in (_levels[level]["path"] as String).split('')) {
        TileType? t = _parse(type);
        if (t != null) {
          cache.update(t, (value) => value + 1, ifAbsent: () => 1);
        }
      }
      for (TileType type in cache.keys) {
        result.add(Option(type, cache[type]!));
      }
    }
    return result;
  }

  static TileType? _parse(String s){
    switch(s){
      case 's':
        return TileType.line;
      case 'l':
        return TileType.left;
      case 'r':
        return TileType.right;
      case 'c':
        return TileType.cross;
    }
    return null;
  }
}