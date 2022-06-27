import 'dart:ui';

import 'package:flutter/material.dart';

import 'resources.dart';

class ThemeUtils{
  static const TextTheme textTheme = TextTheme(
    labelSmall: TextStyle(
        color: Resources.primary,
        fontSize: 24,
        fontWeight: FontWeight.bold
    ),
    labelMedium: TextStyle(
        color: Resources.primary,
        fontSize: 32,
        fontWeight: FontWeight.bold
    ),
    labelLarge: TextStyle(
        color: Resources.primary,
        fontSize: 56,
        fontWeight: FontWeight.bold
    ),
    bodyMedium:  TextStyle(
        color: Resources.primary,
        fontSize: 24
    ),
    displayMedium: TextStyle(
      color: Colors.grey,
      fontSize: 32
    )
  );
}