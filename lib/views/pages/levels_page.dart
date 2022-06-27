import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trail/utils/game_data.dart';
import 'package:trail/utils/themes.dart';
import 'package:trail/views/shared/custom_button.dart';

class LevelsPage extends StatelessWidget {
  final int current;
  const LevelsPage({
    Key? key,
    this.current = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              crossAxisCount: 4,
            ),
            itemCount: GameData.size-1,
            itemBuilder: (context, index) {
              return CustomButton(
                onPress: () {
                  Navigator.pushReplacementNamed(context, '/game',
                      arguments: {'level': index});
                },
                active: index <= GameData.max,
                label: '${index + 1}',
                border: true,
                textStyle: ThemeUtils.textTheme.labelSmall,
              );
            }),
      ),
    );
  }
}
