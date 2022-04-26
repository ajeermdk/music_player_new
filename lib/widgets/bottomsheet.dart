import 'package:flutter/material.dart';

import 'package:music_player_new/db/songmodel.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../db/box.dart';

// ignore: must_be_immutable, camel_case_types
class buildSheet extends StatefulWidget {
  String playlistName;
  buildSheet({Key? key, required this.playlistName}) : super(key: key);

  @override
  _buildSheetState createState() => _buildSheetState();
}

// ignore: camel_case_types
class _buildSheetState extends State<buildSheet> {
  final box = Boxes.getInstance();

  List<SongsDB> dbSongs = [];
  List<SongsDB> playlistSongs = [];
  @override
  void initState() {
    super.initState();
    getSongs();
  }

  getSongs() {
    dbSongs = box.get("musics") as List<SongsDB>;
    playlistSongs = box.get(widget.playlistName)!.cast<SongsDB>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
      child: ListView.builder(
        itemCount: dbSongs.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: SizedBox(
                height: 50,
                width: 50,
                child: QueryArtworkWidget(
                  id: int.parse(dbSongs[index].id.toString()),
                  type: ArtworkType.AUDIO,
                  artworkBorder: BorderRadius.circular(15),
                  artworkFit: BoxFit.cover,
                  nullArtworkWidget: Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      image: DecorationImage(
                        image: AssetImage("assets/images/tune_logo.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(
                dbSongs[index].title!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500,color: Colors.white),
              ),
              trailing: playlistSongs
                      .where((element) =>
                          element.id.toString() == dbSongs[index].id.toString())
                      .isEmpty
                  ? IconButton(
                      onPressed: () async {
                        playlistSongs.add(dbSongs[index]);
                        await box.put(widget.playlistName, playlistSongs);
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    )
                  : IconButton(
                      onPressed: () async {
                        playlistSongs.removeWhere(
                          (elemet) =>
                              elemet.id.toString() ==
                              dbSongs[index].id.toString(),
                        );
                        await box.put(widget.playlistName, playlistSongs);
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.remove,
                         color: Colors.white,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
