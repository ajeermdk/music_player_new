import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player_new/db/songmodel.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../cls/cls.dart';
import '../db/box.dart';
import '../widgets/now_playing.dart';

class SearchScreen extends StatefulWidget {
  List<Audio> fullSongs = [];

  SearchScreen({Key? key, required this.fullSongs}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final box = Boxes.getInstance();

  String search = "";

  List<SongsDB> dbSongs = [];

  List<Audio> allSongs = [];

  searchSongs() {
    dbSongs = box.get("musics") as List<SongsDB>;
    dbSongs.forEach(
      (element) {
        allSongs.add(
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
  }

  @override
  void initState() {
    super.initState();
    searchSongs();
  }

  @override
  Widget build(BuildContext context) {
    List<Audio> searchArtist = allSongs.where((element) {
      return element.metas.artist!.toLowerCase().startsWith(
            search.toLowerCase(),
          );
    }).toList();
    List<Audio> searchTitle = allSongs.where((element) {
      return element.metas.title!.toLowerCase().startsWith(
            search.toLowerCase(),
          );
    }).toList();
    List<Audio> searchResult = searchTitle + searchArtist;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SafeArea(
        child: Container(
          height: 950,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 19, 16, 26),
              Color.fromARGB(255, 19, 16, 26),
              Color.fromARGB(255, 33, 26, 34),
              Color.fromARGB(255, 34, 23, 32),
              Color.fromARGB(255, 34, 23, 32),
              Color.fromARGB(255, 34, 23, 32),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: Row(
                    children:  [
                      IconButton(onPressed: (){
                        Navigator.of(context).pop();
                      }, icon: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,)),
                      const SizedBox(
                        width: 15,
                      ),
                      const Text(
                        'Search',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)),
                  child:TextField(
                    style: const TextStyle(
                      color: Color.fromARGB(172, 255, 255, 255),
                    ),
                    //enabled: searchButton,
                    //controller: _searchController,
                    decoration: const InputDecoration(
                      fillColor: Color.fromARGB(255, 42, 34, 65),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(90, 42, 34, 65), width: 1.0),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color.fromARGB(134, 255, 255, 255),
                      ),
                      hintText: "Search here..",
                      hintStyle: TextStyle(
                        color: Color.fromARGB(134, 255, 255, 255),
                        fontSize: 17,
                      ),
                    ),
                     onChanged: (value) {
                          setState(
                            () {
                              search = value;
                            },
                          );
                        },
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                search.isNotEmpty
                    ? searchResult.isNotEmpty
                        ? Expanded(
                            child: Stack(
                              children: [
                                ListView.builder(
                                  itemCount: searchResult.length,
                                  itemBuilder: ((context, index) {
                                    return FutureBuilder(
                                      future: Future.delayed(
                                        const Duration(microseconds: 0),
                                      ),
                                      builder: ((context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return GestureDetector(
                                            onTap: () {
                                              OpenPlayer(
                                                      fullSongs: searchResult,
                                                      index: index)
                                                  .openAssetPlayer(
                                                      index: index,
                                                      songs: searchResult);
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return NowPlaying(
                                                    allSongs: allSongs,
                                                    index: index);
                                              }));
                                            },
                                            child: ListTile(
                                              leading: SizedBox(
                                                height: 50,
                                                width: 50,
                                                child: QueryArtworkWidget(
                                                  id: int.parse(
                                                      searchResult[index]
                                                          .metas
                                                          .id!),
                                                  type: ArtworkType.AUDIO,
                                                  artworkBorder:
                                                      BorderRadius.circular(15),
                                                  artworkFit: BoxFit.cover,
                                                  nullArtworkWidget: Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(15),
                                                      ),
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/images/tune_logo.png'),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                searchResult[index]
                                                    .metas
                                                    .title!,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              subtitle: Text(
                                                searchResult[index]
                                                    .metas
                                                    .artist!,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          );
                                        }
                                        return Container();
                                      }),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.all(30),
                            child: Text(
                              "No Result Found",
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                          )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
