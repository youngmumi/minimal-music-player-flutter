import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:minimal_music_player/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  final List<Song> _playlist = [
    //Song 1
    Song(
      songName: "Flower",
      artistName: "Miley Cyrus",
      albumArtImagePath: "assets/images/album_image1.jpg",
      audioPath: "audio/flower.mp3",
    ),

    //Song 2
    Song(
      songName: "Blow your mind",
      artistName: "Dua lipa",
      albumArtImagePath: "assets/images/album_image2.jpg",
      audioPath: "audio/flower.mp3",
    ),

    //Song 3
    Song(
      songName: "Levitating",
      artistName: "Dua lipa",
      albumArtImagePath: "assets/images/album_image3.jpg",
      audioPath: "audio/flower.mp3",
    )
  ];

  int? _currentSongIndex;

  final AudioPlayer _audioPlayer = AudioPlayer();

  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  PlaylistProvider() {
    listenToDuration();
  }

  bool _isPlaying = false;

  void play() async {
    if (_currentSongIndex == null) {
      currentSongIndex = 0; // Ensure there is a song to play
    }
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        currentSongIndex = 0;
      }
      play(); // Start playing the next song
    }
  }

  void playPreviousSong() async {
    if (_currentDuration.inSeconds > 2) {
      // If more than 2 seconds has passed, seek back to start
      await _audioPlayer.seek(Duration.zero);
    } else {
      if (_currentSongIndex != null && _currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        currentSongIndex = _playlist.length - 1;
      }
      play(); // Start playing the previous song
    }
  }

  void listenToDuration() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong(); // Automatically play the next song when the current one finishes
    });
  }

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play();
    }

    notifyListeners();
  }
}
