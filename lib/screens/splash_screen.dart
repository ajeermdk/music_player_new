
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import 'package:music_player_new/db/songmodel.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:mp3_info/mp3_info.dart';
import '../db/box.dart';
import '../screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    fetchSongs();
    gotoHome();
    super.initState();
  }

  final box = Boxes.getInstance();
  final _audioQuery = OnAudioQuery();
  List<SongsDB> mappedSongs = [];
  List<SongsDB> dbSongs = [];
  List<SongModel> fetchedSongs = [];
  List<SongModel> allSongs = [];
  List<Audio> audioSongs = [];

  fetchSongs() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
    }
    allSongs = await _audioQuery.querySongs();
    

    mappedSongs = allSongs
        .map((e) => SongsDB(
            title: e.title,
            artist: e.artist,
            duration: e.duration.toString(),
            id: e.id.toString(),
            image: e.uri))
        .toList();

    await box.put("musics", mappedSongs);
    dbSongs = box.get("musics") as List<SongsDB>;

    for (var element in dbSongs) {
      audioSongs.add(Audio.file(element.image.toString(),
          metas: Metas(
              title: element.title,
              id: element.id.toString(),
              artist: element.artist)));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 19, 16, 26),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(
                height: screenHeight / 3,
              ),
              Image(
                width: screenWidth / 1.3,
                image: const AssetImage('assets/images/tune_logo.png'),
              ),
              SizedBox(
                height: screenHeight / 4,
              ),
              const Text(
                'tune',
                style: TextStyle(
                  letterSpacing: 7,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 50,
                ),
              )
            ],
          ),
        ));
  }

  Future<void> gotoHome() async {
    await Future.delayed(const Duration(seconds: 3));

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => HomeScreen(
              allSongs: audioSongs,
            )));
  }
}
