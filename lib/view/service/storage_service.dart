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
}
