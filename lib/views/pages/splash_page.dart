import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trail/utils/game_data.dart';
import 'package:trail/views/shared/splash_painter.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  final Tween<double> _rotationTween = Tween(begin: 0, end: 2 * pi);

  @override
  void initState() {
    initialization();
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = _rotationTween.animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.pushReplacementNamed(context, '/game',
              arguments: {'level': GameData.level});
        }
      });

    run();
  }

  void initialization() async {
    await GameData.initialize();
  }

  void run() async {
    await Future.delayed(const Duration(milliseconds: 200));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          builder: (context, _) => CustomPaint(
            painter: SplashPainter(animation.value),
            child: Container(),
          ),
          animation: animation,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
