import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trail/views/shared/toggle_button.dart';

import '../../utils/game_data.dart';
import '../../utils/themes.dart';
import 'custom_button.dart';

class Menu extends StatefulWidget {
  final Map<String, Function> actions;

  const Menu({Key? key, required this.actions}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MenuState();
}

class MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sounds',
              style: ThemeUtils.textTheme.bodyMedium,
            ),
            ToggleTextButton(
                value: GameData.sounds,
                onChange: (value) {
                  GameData.saveSounds(value);
                })
          ],
        ),
        const SizedBox(height: 16),
        ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) =>
              CustomButton(
                  onPress: () {
                    Navigator.pop(context);
                    widget.actions.values.toList()[index]();
                  },
                  label: widget.actions.keys.toList()[index]),
            separatorBuilder: (context, index) =>
              const SizedBox(height: 16),
            itemCount: widget.actions.length),
      ],
    );
  }
}
