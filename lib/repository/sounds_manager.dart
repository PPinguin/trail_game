import 'package:audioplayers/audioplayers.dart';
import 'package:trail/repository/game_data.dart';

class SoundsManager{
  static final AudioPlayer _playerStep = AudioPlayer();
  static final AudioPlayer _playerComplete = AudioPlayer();
  static final AudioPlayer _playerClick = AudioPlayer();

  static void init() async {
    await _playerStep.setSource(AssetSource('sounds/step_sound.wav'));
    await _playerComplete.setSource(AssetSource('sounds/complete_sound.wav'));
    await _playerClick.setSource(AssetSource('sounds/click_sound.wav'));
  }

  static void playStep() async {
    if(GameData.sounds) {
      await _playerStep.resume();
    }
  }

  static void playComplete() async{
    if(GameData.sounds) {
      await _playerComplete.resume();
    }
  }

  static void playClick() async{
    if(GameData.sounds) {
      await _playerClick.resume();
    }
  }
}