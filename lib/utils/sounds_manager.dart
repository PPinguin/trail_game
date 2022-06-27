import 'package:audioplayers/audioplayers.dart';
import 'package:trail/utils/game_data.dart';

class SoundsManager{
  static final AudioPlayer _player = AudioPlayer();

  static void playStep() async {
    if(GameData.sounds) {
      await _player.play(AssetSource('sounds/step_sound.wav'));
    }
  }

  static void playFail() async{
    if(GameData.sounds) {
      await _player.play(AssetSource('sounds/fail_sound.wav'));
    }
  }

  static void playComplete() async{
    if(GameData.sounds) {
      await _player.play(AssetSource('sounds/complete_sound.wav'));
    }
  }

  static void playClick() async{
    if(GameData.sounds) {
      await _player.play(AssetSource('sounds/click_sound.wav'));
    }
  }
}