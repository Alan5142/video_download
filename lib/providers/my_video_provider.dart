import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:video_downlad/db.dart';
import 'package:video_player/video_player.dart';

class MyVideoProvider with ChangeNotifier {
  VideoPlayerController? _vCont;
  VideoPlayerController? get getVidCont => _vCont;
  bool isSaved = false;

  void initializeVideoPlayer(String filePath) async {
    // inicializar el video player
    _vCont = await VideoPlayerController.file(File(filePath))
      ..addListener(() => notifyListeners())
      ..setLooping(false)
      ..initialize().then((value) async {
        // cargar el progreso del video
        await loadConfigs();
        notifyListeners();
      });
  }

  void isPlayOrPause(bool isPlay) {
    if (isPlay) {
      _vCont!.pause();
    } else {
      _vCont!.play();
    }
    notifyListeners();
  }

  // cargar datos
  Future<void> loadConfigs() async {
    var storedValue = await SqliteDb.get("video_time");
    if (_vCont != null && storedValue != null) {
      int milis = int.tryParse(storedValue) ?? 0;
      Duration position = Duration(milliseconds: milis);
      await _vCont!.seekTo(position);
      await _vCont!.setVolume(1);
    }
    notifyListeners();
  }

  // guardar datos
  Future saveConfigs() async {
    try {
      Duration position = _vCont!.value.position;
      await SqliteDb.insert("video_time", position.inMilliseconds.toString());
      isSaved = true;
      notifyListeners();
    } catch (e) {
      print("Error al guardar: ${e.toString()}");
      isSaved = false;
      notifyListeners();
    }
  }
}
