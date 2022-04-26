import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player_new/db/songmodel.dart';

import 'package:music_player_new/screens/library_screen.dart';
import 'package:music_player_new/screens/playlists_screen.dart';
import 'package:music_player_new/screens/search_screen.dart';
import 'package:music_player_new/screens/settings_screen.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:on_audio_query/on_audio_query.dart';

import '../cls/cls.dart';
import '../db/box.dart';

import '../openassetaudio/openassetaudio.dart';
import '../widgets/buildsheet.dart';

import '../widgets/now_playing.dart';
import '../widgets/snakbars.dart';

class HomeScreen extends StatefulWidget {
  List<Audio> allSongs;

  HomeScreen({Key? key, required this.allSongs}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String search = "";
  List? dbSongs = [];
  List playlists = [];
  List<dynamic>? favorites = [];
  String? playlistName = '';
  List<dynamic>? likedSongs = [];

  final box = Boxes.getInstance();
  final AssetsAudioPlayer assetAudioPlayer = AssetsAudioPlayer.withId("0");
  final audioQuery = OnAudioQuery();

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  @override
  void initState() {
    super.initState();
    dbSongs = box.get("musics");
    likedSongs = box.get("favorites");
  }

  // void searchButtonClicked() {
  //   setState(() {
  //     searchButton = true;
  //   });
  // }

  // userTappedSomewhere() {
  //   setState(() {
  //     searchButton = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      //extendBody: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 19, 16, 26),
        elevation: 0,
        title: const Text(
          'tune',
          style: TextStyle(
            fontSize: 28,
            letterSpacing: 2,
          ),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => SearchScreen(
                              fullSongs: widget.allSongs,
                            )));
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 255, 255, 255),
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsScreen()));
                  },
                  icon: const Icon(
                    Icons.settings,
                    color: Color.fromARGB(255, 255, 255, 255),
                  )),
            ],
          ),
        ],
      ),

      body: Container(
        // height: double.infinity,
        // width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Color.fromARGB(255, 19, 16, 26),
              Color.fromARGB(255, 19, 16, 26),
              Color.fromARGB(255, 33, 26, 34),
              Color.fromARGB(255, 34, 23, 32),
              Color.fromARGB(255, 34, 23, 32),
              Color.fromARGB(255, 34, 23, 32),
            ])),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height: screenHeight / 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => PlaylistsScreen(
                                allSongs: widget.allSongs,
                                playlistName: "favorites",
                              )));
                    },
                    child: Column(
                      children: const [
                        Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 50,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Favorites",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: screenWidth / 4.5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) =>
                              LibraryScreen(allSongs: widget.allSongs)));
                    },
                    child: Column(
                      children: const [
                        Icon(
                          Icons.library_music_rounded,
                          color: Colors.white,
                          size: 50,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Library",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight / 100,
              ),
              SizedBox(
                height: screenHeight / 60,
              ),
              const SizedBox(
                width: 350,
                child: Divider(
                  color: Color.fromARGB(106, 255, 255, 255),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.allSongs.length,
                  itemBuilder: (context, index) {
                    String artist;
                    if (widget.allSongs[index].metas.artist.toString() ==
                        "<unknown>") {
                      artist = "No Artist";
                    } else {
                      artist = widget.allSongs[index].metas.artist.toString();
                    }
                    //final _duration = assetAudioPlayer.setPitch(1);
                    //print(_duration);

                    return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: QueryArtworkWidget(
                              artworkHeight: 50,
                              artworkWidth: 50,
                              artworkFit: BoxFit.contain,
                              nullArtworkWidget: Image.asset(
                                "assets/images/tune_logo.png",
                                height: 55,
                                width: 55,
                                fit: BoxFit.cover,
                              ),
                              id: int.parse(
                                  widget.allSongs[index].metas.id.toString()),
                              type: ArtworkType.AUDIO),
                        ),
                        title: Text(
                          widget.allSongs[index].metas.title.toString(),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 251, 252, 251),
                              fontSize: 15),
                        ),
                        subtitle: Text(
                          artist,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10),
                        ),
                        onTap: () async {
                          OpenAssetAudio(allsong: widget.allSongs, index: index)
                              .openAsset(index: index, audios: widget.allSongs);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return NowPlaying(
                                  index: index,
                                  allSongs: widget.allSongs,
                                );
                              },
                            ),
                          );
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              likedSongs = box.get("favorites");
                              return Dialog(
                                backgroundColor:
                                    const Color.fromARGB(0, 255, 255, 255),
                                child: Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 53, 37, 56),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(17.0),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              widget.allSongs[index].metas.title
                                                  .toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 106, 211, 106),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            ListTile(
                                              title: const Text(
                                                "Add to Playlist",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 250, 249, 249),
                                                    fontSize: 18),
                                              ),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                showModalBottomSheet(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 53, 37, 56),
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                      top: Radius.circular(30),
                                                    ),
                                                  ),
                                                  context: context,
                                                  builder: (context) =>
                                                      BuildSheet(
                                                    song:
                                                        widget.allSongs[index],
                                                  ),
                                                );
                                              },
                                            ),
                                            //likedSongs!=null?
                                            likedSongs!
                                                    .where((element) =>
                                                        element.id.toString() ==
                                                        dbSongs![index]
                                                            .id
                                                            .toString())
                                                    .isEmpty
                                                ? ListTile(
                                                    title: const Text(
                                                      "Add to Favorites",
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              252,
                                                              250,
                                                              250),
                                                          fontSize: 18),
                                                    ),
                                                    onTap: () async {
                                                      final songs =
                                                          box.get("musics")
                                                              as List<SongsDB>;
                                                      final temp = songs
                                                          .firstWhere((element) =>
                                                              element.id
                                                                  .toString() ==
                                                              widget
                                                                  .allSongs[
                                                                      index]
                                                                  .metas
                                                                  .id
                                                                  .toString());
                                                      favorites = likedSongs;
                                                      favorites?.add(temp);
                                                      box.put("favorites",
                                                          favorites!);

                                                      Navigator.of(context)
                                                          .pop();
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBars()
                                                                  .likedAdd);
                                                    },
                                                  )
                                                : ListTile(
                                                    title: const Text(
                                                      "Remove from Favorites",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    trailing: const Icon(
                                                      Icons.favorite_rounded,
                                                      color: Colors.redAccent,
                                                    ),
                                                    onTap: () async {
                                                      likedSongs?.removeWhere(
                                                          (elemet) =>
                                                              elemet.id
                                                                  .toString() ==
                                                              dbSongs![index]
                                                                  .id
                                                                  .toString());
                                                      await box.put("favorites",
                                                          likedSongs!);
                                                      setState(() {});

                                                      Navigator.of(context)
                                                          .pop();
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBars()
                                                                  .likedRemove);
                                                    },
                                                  ) //:Container(),
                                          ]),
                                    )),
                              );
                            },
                          );
                        });
                  },
                ),
              )
            ],
          ),
        ),
      ),
      bottomSheet: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NowPlaying(
                index: 0,
                allSongs: widget.allSongs,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: assetAudioPlayer.builderCurrent(
            builder: (context, playing) {
              final myaudio =
                  find(widget.allSongs, playing.audio.assetAudioPath);
              String artist;
              if (myaudio.metas.artist.toString() == "<unknown>") {
                artist = 'No artist';
              } else if (myaudio.metas.artist!.length > 10) {
                artist = myaudio.metas.artist!
                    .replaceRange(10, myaudio.metas.artist!.length, "...")
                    .toString();
              } else {
                artist = myaudio.metas.artist.toString();
              }
              var titleCut;
              if (myaudio.metas.title!.length > 10) {
                titleCut = myaudio.metas.title!
                    .replaceRange(10, myaudio.metas.title!.length, "...");
              } else {
                titleCut = myaudio.metas.title;
              }
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(2, 2),
                          blurRadius: 20,
                          color: Color.fromARGB(103, 66, 48, 89),
                        )
                      ],
                      color: const Color.fromARGB(255, 20, 12, 33),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(5.0),
                      leading: QueryArtworkWidget(
                        id: int.parse(myaudio.metas.id!),
                        type: ArtworkType.AUDIO,
                        artworkBorder: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            topLeft: Radius.circular(10)),
                        artworkFit: BoxFit.cover,
                        nullArtworkWidget: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: const DecorationImage(
                              image: AssetImage("assets/images/tune_logo.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        titleCut,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      subtitle: Text(
                        artist,
                        style: const TextStyle(
                          color: Color.fromARGB(123, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 212.0),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 13.0),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              assetAudioPlayer.previous();
                            },
                            icon: const Icon(
                              Icons.skip_previous_rounded,
                              size: 40,
                              color: Color.fromARGB(255, 164, 80, 185),
                            ),
                          ),
                          PlayerBuilder.isPlaying(
                              player: assetAudioPlayer,
                              builder: (context, isPlaying) {
                                return IconButton(
                                  onPressed: () async {
                                    await assetAudioPlayer.playOrPause();
                                  },
                                  icon: Icon(
                                      isPlaying
                                          ? Icons.pause_rounded
                                          : Icons.play_arrow_rounded,
                                      size: 40,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                );
                              }),
                          IconButton(
                            onPressed: () {
                              assetAudioPlayer.next();
                            },
                            icon: const Icon(Icons.skip_next_rounded,
                                size: 40,
                                color: Color.fromARGB(255, 164, 80, 185)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // void ifSearchButtonEmpty()
}
