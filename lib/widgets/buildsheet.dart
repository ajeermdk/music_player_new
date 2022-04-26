import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player_new/widgets/snakbars.dart';

import '../db/box.dart';
import '../db/songmodel.dart';

// ignore: must_be_immutable
class BuildSheet extends StatefulWidget {
  BuildSheet({Key? key, this.song}) : super(key: key);
  Audio? song;

  @override
  State<BuildSheet> createState() => _BuildSheetState();
}

class _BuildSheetState extends State<BuildSheet> {
  LinearGradient gradient = const LinearGradient(colors: <Color>[
    Color.fromARGB(223, 169, 25, 182),
    Color.fromARGB(255, 129, 9, 123),
    Color.fromARGB(255, 73, 13, 151),
    Color.fromARGB(255, 107, 16, 143),
    Color.fromARGB(255, 117, 15, 143),
    Color.fromARGB(255, 170, 14, 175),
    Color.fromARGB(255, 4, 74, 102)
  ]);
  List playlists = [];

  String? playlistName = '';

  List<dynamic>? playlistSongs = [];

  @override
  Widget build(BuildContext context) {
    final box = Boxes.getInstance();
    playlists = box.keys.toList();
    return Container(
      padding: const EdgeInsets.only(top: 30, bottom: 20),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
            child: ListTile(
              onTap: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  backgroundColor: const Color.fromARGB(255, 53, 37, 56),
                  title: const Text(
                    "Add new Playlist",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 102, 197, 105)),
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
                            color: Color.fromARGB(255, 240, 237, 237),
                          ),
                        ))
                  ],
                ),
              ),
              leading: Container(
                height: 50,
                width: 55,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(149, 0, 0, 0),
                  borderRadius: BorderRadius.all(Radius.circular(17)),
                ),
                child: const Center(
                    child: Icon(
                  Icons.add,
                  color: Color.fromARGB(183, 252, 250, 250),
                  size: 28,
                )),
              ),
              title: const Text(
                "Create Playlist",
                style: TextStyle(
                  color: Color.fromARGB(183, 252, 250, 250),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ...playlists
              .map((e) => e != "musics" && e != "favorites"
                  ? libraryList(
                      child: ListTile(
                      onTap: () async {
                        playlistSongs = box.get(e);
                        List existingSongs = [];
                        existingSongs = playlistSongs!
                            .where((element) =>
                                element.id.toString() ==
                                widget.song!.metas.id.toString())
                            .toList();

                        if (existingSongs.isEmpty) {
                          final songs = box.get("musics") as List<SongsDB>;
                          final temp = songs.firstWhere((element) =>
                              element.id.toString() ==
                              widget.song!.metas.id.toString());
                          playlistSongs?.add(temp);

                          await box.put(e, playlistSongs!);

                          // setState(() {});
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBars().songAdded);
                        } else {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBars().excistingSong);
                        }
                      },
                      leading: Container(
                        width: 55,
                        height: 50,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(1, 1),
                              blurRadius: 8,
                              color: Color.fromARGB(76, 122, 109, 136),
                            )
                          ],
                          borderRadius: BorderRadius.circular(17),
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
                          onPressed: () async {
                            playlistSongs = box.get(e);
                            List existingSongs = [];
                            existingSongs = playlistSongs!
                                .where((element) =>
                                    element.id.toString() ==
                                    widget.song!.metas.id.toString())
                                .toList();

                            if (existingSongs.isEmpty) {
                              final songs = box.get("musics") as List<SongsDB>;
                              final temp = songs.firstWhere((element) =>
                                  element.id.toString() ==
                                  widget.song!.metas.id.toString());
                              playlistSongs?.add(temp);

                              await box.put(e, playlistSongs!);

                              // setState(() {});
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBars().songAdded);
                            } else {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBars().excistingSong);
                            }
                          },
                          child: const Icon(
                            Icons.playlist_play_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      title: Text(
                        e.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ))
                  : Container())
              .toList()
        ],
      ),
    );
  }

  Padding libraryList({required child}) {
    return Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
        child: child);
  }
}
