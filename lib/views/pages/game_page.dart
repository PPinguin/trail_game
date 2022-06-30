import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trail/models/game_model.dart';
import 'package:trail/repository/ad_manager.dart';
import 'package:trail/utils/resources.dart';
import 'package:trail/repository/sounds_manager.dart';
import 'package:trail/utils/themes.dart';
import 'package:trail/views/shared/game_painter.dart';
import 'package:trail/views/shared/option_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../shared/menu.dart';

class GamePage extends StatefulWidget {
  final int level;
  final bool redraw;

  const GamePage({Key? key, this.level = 0, this.redraw = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  late AnimationController movementController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));

  late AnimationController uiController = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final Animation<Offset> buttonsAnimation = Tween<Offset>(
    begin: const Offset(0.0, 0.25),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: uiController,
    curve: Curves.easeIn,
  ));

  late int displayLevel;

  @override
  void initState() {
    super.initState();
    context.read<GameModel>().initLevel(widget.level);
    context.read<GameModel>()
      ..setLevelCallback = (level) {
        SoundsManager.playComplete();
        setLevel(context, level);
      }
      ..restartCallback = () {
        restart(context);
      };
    displayLevel = widget.level + 1;
    if (widget.redraw) {
      uiController.forward();
      context.read<GameModel>().discardSolution();
      AdManager.createRewardedAd();
    } else {
      uiController.forward(from: 1);
      if (context.read<GameModel>().solution.isNotEmpty) {
        context.read<GameModel>().showNextStep();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        Consumer<GameModel>(
          builder: (context, model, child) {
            movementController.reset();
            movementController.forward();
            return AnimatedBuilder(
              builder: (context, child) {
                return Transform.rotate(
                  angle: (model.r - model.dr * (1 - movementController.value)) *
                      pi /
                      2,
                  child: Transform.translate(
                      offset: Offset(
                          (model.x -
                                  model.dx * (1 - movementController.value)) *
                              2 *
                              Resources.scale,
                          (model.y -
                                  model.dy * (1 - movementController.value)) *
                              2 *
                              Resources.scale),
                      child: child),
                );
              },
              animation: movementController,
              child: CustomPaint(
                painter: GamePainter(
                  tiles: model.list,
                ),
                child: Container(),
              ),
            );
          },
        ),
        SlideTransition(
          position: buttonsAnimation,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ListView.separated(
                padding: const EdgeInsets.only(right: 12, left: 12, bottom: 8),
                separatorBuilder: (context, i) => const SizedBox(width: 12),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: context.read<GameModel>().buttons.length,
                itemBuilder: (context, i) {
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: OptionButton(
                        context: context,
                        option: context.watch<GameModel>().buttons.toList()[i]),
                  );
                }),
          ),
        ),

        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  enableFeedback: false,
                  icon: SvgPicture.asset('assets/icons/menu.svg'),
                  onPressed: () {
                    SoundsManager.playClick();
                    pause(context);
                  },
                ),
                Text(
                    context.read<GameModel>().buttons.isNotEmpty
                        ? displayLevel.toString()
                        : 'finish',
                    style: ThemeUtils.textTheme.labelMedium),
                IconButton(
                  enableFeedback: false,
                  icon: SvgPicture.asset('assets/icons/restart.svg'),
                  onPressed: () {
                    if (context.read<GameModel>().status == GameStatus.game) {
                      SoundsManager.playClick();
                      context.read<GameModel>().restart();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        context.read<GameModel>().message != null
            ? Align(
                alignment: const Alignment(0.0, 0.5),
                child: FadeTransition(
                  opacity: uiController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(context.read<GameModel>().message!,
                        textAlign: TextAlign.center,
                        style: ThemeUtils.textTheme.displayMedium),
                  ),
                ),
              )
            : Container()
      ]),
    ));
  }

  void restart(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, '/game',
        arguments: {'level': widget.level, 'redraw': false});
  }

  void setLevel(BuildContext context, int level) async {
    uiController.reverse();
    await Future.delayed(const Duration(milliseconds: 500));
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, '/game',
        arguments: {'level': level});
  }

  void pause(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text(
              'Menu',
              style: ThemeUtils.textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
            content: Menu(actions: {
              'Get solution': () {
                AdManager.showRewardedAd(
                    reward: () => getSolution(),
                    failed: () => error());
              },
              'Levels': () {
                Navigator.pushNamed(context, '/levels',
                    arguments: {'current': widget.level});
              }
            }),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)))));
  }

  void getSolution(){
    context.read<GameModel>().getSolution();
  }

  void error() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text(
              'Something went wrong. Check your connection.',
              style: ThemeUtils.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)))));
  }

  @override
  void dispose() {
    movementController.dispose();
    uiController.dispose();
    super.dispose();
  }
}
