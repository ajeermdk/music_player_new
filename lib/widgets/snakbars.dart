import 'package:flutter/material.dart';

class SnackBars {
  final excistingPlaylist = SnackBar(
    content: const Text(
      'Excisting playlist name',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.grey[900],
  );
  final excistingSong = SnackBar(
    content: const Text(
      'Song already exists',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.grey[900],
  );
  final songAdded = SnackBar(
    content: const Text(
      'Song added to Playlist',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.grey[900],
  );
  final likedAdd = SnackBar(
    content: const Text(
      'Song added to Favorites',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.grey[900],
  );
  final likedRemove = SnackBar(
    content: const Text(
      'Song removed from Favorites',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.grey[900],
  );
}
