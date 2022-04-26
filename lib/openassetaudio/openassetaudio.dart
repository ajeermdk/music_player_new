import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpenAssetAudio {
  List<Audio> allsong;
  int index;
  bool? notify;
  Future<bool?> setNotifyValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notify = prefs.getBool("switchState"); //await is used before pref
    return notify;
  }

  OpenAssetAudio({required this.allsong, required this.index});
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId("0");
  Future<void> openAsset({List<Audio>? audios, required int index}) async {
    notify = await setNotifyValue();
    await audioPlayer.open(Playlist(audios: audios, startIndex: index),
        showNotification: notify == null || notify == true ? true : false,
        notificationSettings: const NotificationSettings(
          stopEnabled: false,
        ),
        autoStart: true,
        loopMode: LoopMode.playlist);
  }
}
