import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../db/box.dart';
import '../db/songmodel.dart';
import '../openassetaudio/openassetaudio.dart';
import '../widgets/bottomsheet.dart';
import '../widgets/now_playing.dart';

class PlaylistsScreen extends StatefulWidget {
  final List<Audio> allSongs;
   String? playlistName;
   PlaylistsScreen({Key? key,  this.playlistName, required this.allSongs,})
      : super(key: key);

  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  List<SongsDB>? dbSongs = [];

  List<SongsDB> playlistSongs = [];
  List<Audio> playPlaylist = [];
final box = Boxes.getInstance();
  @override
  Widget build(BuildContext context) {
    
    final AssetsAudioPlayer assetAudioPlayer = AssetsAudioPlayer.withId("0");
    Audio find(List<Audio> source, String fromPath) {
      return source.firstWhere((element) => element.path == fromPath);
    }

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: Color.fromARGB(71, 130, 77, 140),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                  ),
                  context: context,
                  builder: (context) {
                    return buildSheet(
                      playlistName: widget.playlistName!,
                    );
                  },
                );
              },
              icon: Icon(Icons.add))
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.keyboard_arrow_left_rounded,
              size: 35,
            )),
        title: Text(widget.playlistName!),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 22, 17, 29),
      ),
      //backgroundColor: const Color.fromARGB(255, 22, 17, 29),
      body: Container(
        width: double.maxFinite,
        height: double.infinity,
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
                height: 500,
                width: double.infinity,
                child: ValueListenableBuilder(
                  valueListenable: box.listenable(),
                  builder: (context, boxes, _) {
                    final playlistSongs = box.get(widget.playlistName)!;
                    return playlistSongs.isEmpty
                        ? const SizedBox(
                            child: Center(
                              child: Text(
                                "No songs here!",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: playlistSongs.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  playlistSongs.forEach(
                                    (element) {
                                      playPlaylist.add(
                                        Audio.file(
                                          element.image.toString(),
                                          metas: Metas(
                                              title: element.title,
                                              id: element.id.toString(),
                                              artist: element.artist),
                                        ),
                                      );
                                    },
                                  );

                                  OpenAssetAudio(
                                          allsong: playPlaylist, index: index)
                                      .openAsset(
                                          index: index, audios: playPlaylist);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NowPlaying(
                                        allSongs: playPlaylist,
                                        index: index,
                                      ),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: QueryArtworkWidget(
                                      id: int.parse(playlistSongs[index].id!),
                                      type: ArtworkType.AUDIO,
                                      artworkBorder:
                                          BorderRadius.circular(15),
                                      artworkFit: BoxFit.cover,
                                      nullArtworkWidget: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/tune_logo.png"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    playlistSongs[index].title!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    playlistSongs[index].artist!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      setState(
                                        () {
                                          playlistSongs.removeAt(index);
                                          box.put(widget.playlistName,
                                              playlistSongs);
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.delete,
                                        color: Colors.white),
                                  ),
                                ),
                              );
                            },
                          );
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
}
