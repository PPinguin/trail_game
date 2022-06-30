import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trail/repository/sounds_manager.dart';

import '../../utils/resources.dart';

class ToggleTextButton extends StatefulWidget{
  final String on;
  final String off;
  final bool value;
  final Function(bool) onChange;
  const ToggleTextButton({
    Key? key,
    this.on = 'On',
    this.off = 'Off',
    required this.onChange,
    this.value = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ToggleTextButtonState();
}

class ToggleTextButtonState extends State<ToggleTextButton>{

  bool _value = false;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        SoundsManager.playClick();
        setState(() {
          _value = !_value;
        });
        widget.onChange(_value);
      },
      style: ButtonStyle(
          shadowColor: MaterialStateProperty
              .resolveWith<Color>((states) => Colors.transparent),
          backgroundColor: MaterialStateProperty
              .resolveWith<Color>((states) => _value ? Resources.primary : Colors.white ),
          fixedSize: MaterialStateProperty
              .resolveWith<Size>((states) => const Size(64, 32)),
          shape: MaterialStateProperty
              .resolveWith<RoundedRectangleBorder>((states) =>
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                side: const BorderSide(
                    color: Resources.primary, width: 3)
              )
          )
      ),
      child: Text(
          _value ? widget.on : widget.off,
          style: TextStyle(
            color: _value ? Colors.white : Resources.primary,
            fontSize: 18
          )
      ),
    );
  }

}