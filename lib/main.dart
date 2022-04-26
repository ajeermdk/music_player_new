import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player_new/db/songmodel.dart';


import 'db/box.dart';
import 'screens/splash_screen.dart';


 Future main() async{
   WidgetsFlutterBinding.ensureInitialized();
   await Hive.initFlutter();
   Hive.registerAdapter(SongsDBAdapter());
   await Hive.openBox<List>(boxname);

   final box = Boxes.getInstance();

   List<dynamic> libraryKeys = box.keys.toList();
   if(!libraryKeys.contains("favorites")){
     List<dynamic> likedSongs = []; 
     await box.put("favorites", likedSongs);
   }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          canvasColor: Colors.transparent,
          textTheme: GoogleFonts.varelaRoundTextTheme(
            Theme.of(context).textTheme,
          ),
          primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}