import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _singleton = StorageService._internal();

  factory StorageService() {
    return _singleton;
  }

  StorageService._internal();

  Future<void> setHighScore(int? highScore) async {
    if (highScore != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('highScore', highScore);
    }
  }

  Future<int> getHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('highScore') ?? 0;
  }

  Future<void> setVibrations(String? vibration) async {
    if (vibration != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('vibration', vibration);
    }
  }

  Future<String> getVibration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('vibration') ?? '';
  }

  Future<void> setAudio(String? audio) async {
    if (audio != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('audio', audio);
    }
  }

  Future<String> getAudio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('audio') ?? '';
  }

  Future<void> setControls(String? controls) async {
    if (controls != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('controls', controls);
    }
  }

  Future<String> getControls() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('controls') ?? '';
  }

  Future<void> setDifficulty(String? difficulty) async {
    if (difficulty != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('difficulty', difficulty);
    }
  }

  Future<String> getDifficulty() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('difficulty') ?? '';
  }
}
