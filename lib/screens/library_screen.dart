import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../db/box.dart';
import '../db/songmodel.dart';
import '../widgets/editplaylistname.dart';
import '../widgets/now_playing.dart';
import '../widgets/snakbars.dart';
import 'playlists_screen.dart';

class LibraryScreen extends StatefulWidget {
  final List<Audio> allSongs;
  const LibraryScreen({Key? key, required this.allSongs}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final box = Boxes.getInstance();
  List playlists = [];
  String? playlistName = '';
  @override
  Widget build(BuildContext context) {
    // final box = Boxes.getInstance();
    final AssetsAudioPlayer assetAudioPlayer = AssetsAudioPlayer.withId("0");
    Audio find(List<Audio> source, String fromPath) {
      return source.firstWhere((element) => element.path == fromPath);
    }

    LinearGradient gradient = const LinearGradient(colors: <Color>[
      Color.fromARGB(223, 169, 25, 182),
      Color.fromARGB(255, 129, 9, 123),
      Color.fromARGB(255, 73, 13, 151),
      Color.fromARGB(255, 107, 16, 143),
      Color.fromARGB(255, 117, 15, 143),
      Color.fromARGB(255, 170, 14, 175),
      Color.fromARGB(255, 4, 74, 102)
    ]);

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.keyboard_arrow_left_rounded,
              size: 35,
            )),
        title: const Text('Your Library'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 22, 17, 29),
      ),
      //backgroundColor: const Color.fromARGB(255, 33, 15, 46),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Color.fromARGB(255, 22, 17, 29),
              Color.fromARGB(255, 22, 17, 29),
              Color.fromARGB(255, 34, 25, 48),
              Color.fromARGB(255, 38, 32, 65),
              Color.fromARGB(255, 36, 40, 61),
              Color.fromARGB(255, 45, 46, 61)
            ])),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight / 40,
              ),
              ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      backgroundColor: const Color.fromARGB(255, 53, 37, 56),
                      title: const Text(
                        "Add new Playlist",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromARGB(255, 106, 211, 106),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      content: TextField(
                        onChanged: (value) {
                          playlistName = value;
                        },
                        autofocus: true,
                        cursorRadius: const Radius.circular(50),
                        cursorColor: Colors.grey,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            List<SongsDB> librayry = [];
                            List? excistingName = [];
                            if (playlists.isNotEmpty) {
                              excistingName = playlists
                                  .where((element) => element == playlistName)
                                  .toList();
                            }

                            if (playlistName != '' && excistingName.isEmpty) {
                              box.put(playlistName, librayry);
                              Navigator.of(context).pop();
                              setState(() {
                                playlists = box.keys.toList();
                              });
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBars().excistingPlaylist);
                            }
                          },
                          child: const Text(
                            "ADD",
                            style: TextStyle(
                              color: Color.fromARGB(255, 233, 225, 225),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
                leading: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    primary: const Color.fromARGB(223, 214, 164, 214),
                    //onPrimary: Colors.indigo,
                    side: const BorderSide(
                      width: 1.0,
                      color: Color.fromARGB(0, 252, 226, 82),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        backgroundColor: const Color.fromARGB(255, 53, 37, 56),
                        title: const Text(
                          "Add new Playlist",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromARGB(255, 106, 211, 106),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        content: TextField(
                          onChanged: (value) {
                            playlistName = value;
                          },
                          style: const TextStyle(
                            color: Colors.white
                          ),
                          autofocus: true,
                          cursorRadius: const Radius.circular(50),
                          cursorColor: Colors.grey,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              List<SongsDB> librayry = [];
                              List? excistingName = [];
                              if (playlists.isNotEmpty) {
                                excistingName = playlists
                                    .where((element) => element == playlistName)
                                    .toList();
                              }

                              if (playlistName != '' && excistingName.isEmpty) {
                                box.put(playlistName, librayry);
                                Navigator.of(context).pop();
                                setState(() {
                                  playlists = box.keys.toList();
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBars().excistingPlaylist);
                              }
                            },
                            child: const Text(
                              "ADD",
                              style: TextStyle(
                                color: Color.fromARGB(255, 233, 225, 225),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 35,
                    height: 55,
                    child: const Icon(
                      Icons.add,
                      color: Color.fromARGB(255, 255, 255, 255),
                      size: 35,
                    ),
                  ),
                ),
                title: const Text(
                  'Create Playlist',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // ListTile(
              //   onTap: () {
              //     Navigator.push(context, MaterialPageRoute(builder: (context) {
              //       return PlaylistsScreen(
              //         playlistName: 'favorites',
              //         allSongs: widget.allSongs,
              //       );
              //     }));
              //   },
              //   leading: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10)),
              //       primary: const Color.fromARGB(223, 214, 164, 214),
              //       //onPrimary: Colors.indigo,
              //       side: const BorderSide(
              //         width: 1.0,
              //         color: Color.fromARGB(0, 252, 226, 82),
              //       ),
              //     ),
              //     onPressed: () {},
              //     child: Container(
              //       alignment: Alignment.center,
              //       width: 35,
              //       height: 55,
              //       child: const Icon(
              //         Icons.favorite,
              //         color: Color.fromARGB(255, 255, 255, 255),
              //         size: 35,
              //       ),
              //     ),
              //   ),
              //   title: const Text(
              //     'Favorites',
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontSize: 20,
              //     ),
              //   ),
              // ),
              SizedBox(
                height: screenHeight / 35,
              ),
              SizedBox(
                width: 67,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Playlists',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(),
                    Divider(
                        thickness: 1.5,
                        color: Color.fromARGB(255, 164, 80, 185)),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: box.listenable(),
                  builder: (context, boxes, _) {
                    playlists = box.keys.toList();
                    return Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: ListView.builder(
                        itemCount: playlists.length,
                        itemBuilder: (context, index) {
                          return Container(
                            //width: double.infinity,
                            child: playlists[index] != "musics" &&
                                    playlists[index] != "favorites"
                                ? ListTile(
                                    title: Text(
                                      playlists[index].toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    leading: Container(
                                      width: 69,
                                      height: 50,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                            offset: Offset(1, 1),
                                            blurRadius: 8,
                                            color: Color.fromARGB(
                                                76, 122, 109, 136),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: gradient,
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.transparent,
                                          onPrimary: Colors.transparent,
                                          onSurface: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          // side: const BorderSide(
                                          //   width: 1.0,
                                          //   color: Color.fromARGB(0, 252, 226, 82),
                                          // ),
                                        ),
                                        onPressed: () {},
                                        child: const Icon(
                                          Icons.playlist_play_rounded,
                                          color: Colors.white,
                                          size: 37,
                                        ),
                                      ),
                                    ),
                                    trailing: popupMenuBar(index),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlaylistsScreen(
                                            playlistName: playlists[index],
                                            allSongs: widget.allSongs,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Container(),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
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

  popupMenuBar(int index) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert_rounded,color: Colors.white,),
      color:  const Color.fromARGB(230, 160, 108, 169),
      itemBuilder: (context) => [
        const PopupMenuItem(
          child: Text(
            'Remove Playlist',
            style: TextStyle(
              color: Colors.white
            ),
          ),
          value: "0",
        ),
        const PopupMenuItem(
          value: "1",
          child: Text(
            "Rename Playlist",
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ],
      onSelected: (value) {
        if (value == "0") {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    backgroundColor: const Color.fromARGB(230, 160, 108, 169),
                    title: Text(
                      playlistName.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    content: const Text('Delete ?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          box.delete(
                            playlists[index],
                          );
                          Navigator.pop(context);
                        },
                        child: const Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('No'),
                      ),
                    ],
                  ));

          setState(() {
            playlists = box.keys.toList();
          });
        }
        if (value == "1") {
          showDialog(
            context: context,
            builder: (context) => EditPlaylist(
              playlistName: playlists[index],
            ),
          );
        }
      },
    );
  }
}
