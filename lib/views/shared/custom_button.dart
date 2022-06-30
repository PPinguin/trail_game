import 'package:flutter/material.dart';
import 'package:trail/utils/resources.dart';
import 'package:trail/repository/sounds_manager.dart';

class CustomButton extends StatelessWidget {

  final String label;
  final Function onPress;
  final bool border;
  final Size size;
  final TextStyle? textStyle;
  final bool active;

  const CustomButton(
      {Key? key,
      required this.onPress,
      required this.label,
      this.border = true,
      this.active = true,
      this.size = const Size(160, 48),
      this.textStyle,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: active ? 1 : 0.5,
      child: ElevatedButton(
        key: key,
        onPressed: active ? () {
          SoundsManager.playClick();
          onPress();
        } : (){},
        style: ButtonStyle(
            enableFeedback: false,
            shadowColor: MaterialStateProperty.resolveWith<Color>(
                    (states) => Colors.transparent),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (states) => border ? Colors.white : Resources.primary),
            fixedSize:
            MaterialStateProperty.resolveWith<Size>((states) => size),
            shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
                    (states) => RoundedRectangleBorder(
                  side: border
                      ? const BorderSide(
                      color: Resources.primary, width: 3)
                      : BorderSide.none,
                  borderRadius: BorderRadius.circular(8),
                ))),
        child: Text(
          label,
          style: textStyle ??
              TextStyle(
                  color: border ? Resources.primary : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
