import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trail/utils/resources.dart';
import 'package:trail/repository/sounds_manager.dart';

import '../../entities/option.dart';
import '../../entities/tile.dart';
import '../../models/game_model.dart';
import '../../utils/themes.dart';

class OptionButton extends StatelessWidget {
  final BuildContext context;
  final Option option;

  const OptionButton({Key? key, required this.context, required this.option})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Opacity(
          opacity: option.number > 0 && option.active ? 1 : 0.5,
          child: ElevatedButton(
              onPressed: () {
                if (option.number > 0 &&
                    context.read<GameModel>().status == GameStatus.game &&
                    option.active) {
                  SoundsManager.playStep();
                  option.number--;
                  Provider.of<GameModel>(context, listen: false)
                      .choose(option.type);
                }
              },
              style: ButtonStyle(
                enableFeedback: false,
                  shadowColor: MaterialStateProperty.resolveWith<Color>(
                      (states) => Colors.transparent),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (states) => Colors.white),
                  fixedSize: MaterialStateProperty.resolveWith<Size>(
                      (states) => const Size(72, 72)),
                  shape:
                      MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
                          (states) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)))),
              child: CustomPaint(
                painter: _ButtonPainter(option.type),
                child: Container(),
              )),
        ),
        const SizedBox(height: 8),
        Text(
          option.number.toString(),
          style: ThemeUtils.textTheme.bodyMedium,
        )
      ],
    );
  }
}

class _ButtonPainter extends CustomPainter {
  final TileType type;

  _ButtonPainter(this.type);

  static final customPaint = Paint()
    ..color = Resources.primary
    ..strokeWidth = 14
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(pi);
    switch (type) {
      case TileType.line:
        canvas.drawLine(Offset(0, -size.height / 4), Offset(0, size.height / 4),
            customPaint);
        break;
      case TileType.right:
        canvas.drawArc(
            Offset(-size.height / 4 * 3, -size.height / 4 * 3) &
                Size(size.height, size.height),
            0,
            pi / 2,
            false,
            customPaint);
        break;
      case TileType.left:
        canvas.drawArc(
            Offset(-size.height / 4, -size.height / 4 * 3) &
                Size(size.height, size.height),
            pi,
            -pi / 2,
            false,
            customPaint);
        break;
      case TileType.cross:
        canvas.drawLine(Offset(0, -size.height / 4), Offset(0, size.height / 4),
            customPaint);
        canvas.drawLine(Offset(-size.height / 4, 0), Offset(size.height / 4, 0),
            customPaint);
        break;
      default:
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
