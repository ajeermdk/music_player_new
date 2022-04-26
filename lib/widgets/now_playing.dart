import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../db/box.dart';
import '../db/songmodel.dart';

//import 'package:flutter_xlider/flutter_xlider.dart';

class NowPlaying extends StatefulWidget {
  List<Audio> allSongs = [];

  int index;
  NowPlaying({
    Key? key,
    required this.allSongs,
    required this.index,
  }) : super(key: key);
  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  //Stream<Playing>? audioStream;

  SongsDB? music;
  final List<StreamSubscription> subscription = [];
  final box = Boxes.getInstance();
  List<SongsDB> dbSongs = [];
  List<dynamic>? likedSongs = [];
  List<dynamic>? favorites = [];

  LinearGradient gradient = const LinearGradient(colors: <Color>[
    Color.fromARGB(255, 62, 2, 117),
    Color.fromARGB(255, 82, 5, 134),
    Color.fromARGB(255, 104, 59, 129),
    Color.fromARGB(255, 123, 66, 136),
    Color.fromARGB(255, 97, 50, 109),
    Color.fromARGB(255, 131, 20, 131),
    Color.fromARGB(255, 190, 41, 183)
  ]);

  //int _duelCommandment = 10;

  @override
  void initState() {
    super.initState();
    dbSongs = box.get("musics") as List<SongsDB>;
  }

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  bool isPlaying = false;
  bool isLooping = false;
  bool isShuffle = false;

  //bool isplaying = false;
  IconData playbtn = Icons.pause_circle_outline_rounded;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 35,
            )),
        title: const Text('Now Playing'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromARGB(220, 21, 2, 48),
      ),
      backgroundColor: const Color.fromARGB(220, 21, 2, 48),
      body: assetsAudioPlayer.builderCurrent(builder: (context, playing) {
        // if (assetsAudioPlayer.onErrorDo == true) {
        //   (handler) {
        //     handler.player.open(
        //         handler.playlist.copyWith(startIndex: handler.playlistIndex),
        //         seek: handler.currentPosition).catchError((e){print(e.toString());});
        //   };
        // }
        final myaudio = find(widget.allSongs, playing.audio.assetAudioPath);
        final currentSong = dbSongs.firstWhere(
            (element) => element.id.toString() == myaudio.metas.id.toString());
        likedSongs = box.get("favorites");
        String artist;
        if (myaudio.metas.artist.toString() == "<unknown>") {
          artist = 'No artist';
        } else if (myaudio.metas.artist!.length > 15) {
          artist = myaudio.metas.artist!
              .replaceRange(15, myaudio.metas.artist!.length, "...")
              .toString();
        } else {
          artist = myaudio.metas.artist.toString();
        }
        var titleCut;
        if (myaudio.metas.title!.length > 15) {
          titleCut = myaudio.metas.title!
              .replaceRange(15, myaudio.metas.title!.length, "...");
        } else {
          titleCut = myaudio.metas.title;
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(65.0),
              child: Stack(
                children: [
                  Container(
                      decoration: const BoxDecoration(boxShadow: [
                        BoxShadow(
                          offset: Offset(2, 2),
                          blurRadius: 30,
                          color: Color.fromARGB(162, 118, 81, 167),
                        )
                      ]),
                      width: screenWidth,
                      height: screenHeight / 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20), // Image border

                        child: QueryArtworkWidget(
                            artworkBorder: BorderRadius.circular(5),
                            artworkHeight: 250,
                            artworkWidth: 250,
                            artworkFit: BoxFit.fill,
                            artworkClipBehavior: Clip.antiAliasWithSaveLayer,
                            nullArtworkWidget: Image.asset(
                              "assets/images/tune_logo.png",
                              height: 250,
                              width: 280,
                              fit: BoxFit.cover,
                            ),
                            id: int.parse(myaudio.metas.id.toString()),
                            type: ArtworkType.AUDIO),
                      )),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  titleCut,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 172, 86, 194),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: screenHeight / 100,
                ),
                Text(
                  artist,
                  style: const TextStyle(
                    color: Color.fromARGB(169, 255, 255, 255),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: screenHeight / 20,
                )
              ],
            ),
            Stack(
              children: [
                seekBarWidget(context),
                SizedBox(
                  height: screenHeight / 18,
                )
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    !isShuffle
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                isShuffle = true;
                                assetsAudioPlayer.toggleShuffle();
                              });
                            },
                            icon: const Icon(
                              Icons.loop_sharp,
                              color: Colors.white,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                isShuffle = false;
                                assetsAudioPlayer
                                    .setLoopMode(LoopMode.playlist);
                              });
                            },
                            icon: const Icon(
                              Icons.shuffle,
                              color: Colors.white,
                            ),
                          ),
                    likedSongs!
                            .where((element) =>
                                element.id.toString() ==
                                currentSong.id.toString())
                            .isEmpty
                        ? IconButton(
                            onPressed: () async {
                              likedSongs?.add(currentSong);
                              box.put("favorites", likedSongs!);
                              likedSongs = box.get("favorites");
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                            ),
                          )
                        : IconButton(
                            onPressed: () async {
                              setState(() {
                                likedSongs?.removeWhere((elemet) =>
                                    elemet.id.toString() ==
                                    currentSong.id.toString());
                                box.put("favorites", likedSongs!);
                              });
                            },
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.white,
                            ),
                          ),
                    !isLooping
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                isLooping = true;
                                assetsAudioPlayer.setLoopMode(LoopMode.single);
                              });
                            },
                            icon: const Icon(
                              Icons.repeat,
                              color: Colors.white,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                isLooping = false;
                                assetsAudioPlayer
                                    .setLoopMode(LoopMode.playlist);
                              });
                            },
                            icon: const Icon(Icons.repeat_one,
                                color: Colors.white),
                          ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          assetsAudioPlayer.previous();
                          setState(() {
                            playbtn = Icons.pause_circle_sharp;
                            isPlaying = false;
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50)),
                            width: 80,
                            height: 80,
                            child: const Icon(
                              Icons.skip_previous_rounded,
                              color: Colors.white,
                              size: 70,
                            )),
                      ),
                      SizedBox(
                        width: screenWidth / 10,
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          if (isPlaying != true) {
                            setState(() {
                              playbtn = Icons.play_circle_filled_sharp;
                              isPlaying = true;
                              assetsAudioPlayer.playOrPause();
                            });
                          } else {
                            setState(() {
                              playbtn = Icons.pause_circle_sharp;
                              isPlaying = false;
                              assetsAudioPlayer.playOrPause();
                            });
                          }
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50)),
                            width: 80,
                            height: 80,
                            child: Icon(
                              playbtn,
                              color: Colors.pink,
                              size: 80,
                            )),
                      ),
                      SizedBox(
                        width: screenWidth / 10,
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          assetsAudioPlayer.next();
                          setState(() {
                            playbtn = Icons.pause_circle_sharp;
                            isPlaying = false;
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50)),
                            width: 80,
                            height: 80,
                            child: const Icon(
                              Icons.skip_next_rounded,
                              color: Colors.white,
                              size: 70,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        );
      }),
    );
  }

  Widget seekBarWidget(BuildContext ctx) {
    return assetsAudioPlayer.builderRealtimePlayingInfos(builder: (ctx, infos) {
      Duration currentPosition = infos.currentPosition;
      Duration total = infos.duration;
      return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: ProgressBar(
          progress: currentPosition,
          total: total,
          onSeek: (to) {
            assetsAudioPlayer.seek(to);
          },
          baseBarColor: Color.fromARGB(255, 190, 190, 190),
          progressBarColor: Color.fromARGB(234, 209, 120, 184),
          bufferedBarColor: Colors.green,
          thumbColor: Color.fromARGB(255, 214, 12, 157),
        ),
      );
    });
  }
}
