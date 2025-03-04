import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _singleton = StorageService._internal();

  factory StorageService() {
    return _singleton;
  }

  StorageService._internal();

  Future<void> setHighScoreForEasy(int? highScore) async {
    if (highScore != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('easyHighScore', highScore);
    }
  }

  Future<int> getHighScoreForEasy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('easyHighScore') ?? 0;
  }

  Future<void> setHighScoreForMedium(int? highScore) async {
    if (highScore != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('mediumHighScore', highScore);
    }
  }

  Future<int> getHighScoreForMedium() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('mediumHighScore') ?? 0;
  }

  Future<void> setHighScoreForHard(int? highScore) async {
    if (highScore != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('hardHighScore', highScore);
    }
  }

  Future<int> getHighScoreForHard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('hardHighScore') ?? 0;
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

  Future<void> setAudioForNumber(String? audio) async {
    if (audio != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('audioNumber', audio);
    }
  }

  Future<String> getAudioForNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('audioNumber') ?? '';
  }

  Future<void> setEasyNumberScore(int? value) async {
    if (value != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('easyNumberScore', value);
    }
  }

  Future<int> getEasyNumberScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('easyNumberScore') ?? 0;
  }

  Future<void> setEasyNumberTimer(int? value) async {
    if (value != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('easyNumberTimer', value);
    }
  }

  Future<int> getEasyNumberTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('easyNumberTimer') ?? 0;
  }

  Future<void> setMediumNumberScore(int? value) async {
    if (value != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('mediumNumberScore', value);
    }
  }

  Future<int> getMediumNumberScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('mediumNumberScore') ?? 0;
  }

  Future<void> setMediumNumberTimer(int? value) async {
    if (value != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('mediumNumberTimer', value);
    }
  }

  Future<int> getMediumNumberTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('mediumNumberTimer') ?? 0;
  }

  Future<void> setHardNumberScore(int? value) async {
    if (value != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('hardNumberScore', value);
    }
  }

  Future<int> getHardNumberScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('hardNumberScore') ?? 0;
  }

  Future<void> setHardNumberTimer(int? value) async {
    if (value != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('hardNumberTimer', value);
    }
  }

  Future<int> getHardNumberTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('hardNumberTimer') ?? 0;
  }

  Future<void> setSoloEasyNumberScore(int? value) async {
    if (value != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('soloEasyNumberScore', value);
    }
  }

  Future<int> getSoloEasyNumberScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('soloEasyNumberScore') ?? 0;
  }

  Future<void> setSoloMediumNumberScore(int? value) async {
    if (value != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('soloMediumNumberScore', value);
    }
  }

  Future<int> getSoloMediumNumberScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('soloMediumNumberScore') ?? 0;
  }

  Future<void> setSoloHardNumberScore(int? value) async {
    if (value != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('soloHardNumberScore', value);
    }
  }

  Future<int> getSoloHardNumberScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('soloHardNumberScore') ?? 0;
  }

  Future<void> setSoloEasyNumberTimer(int? value) async {
    if (value != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('soloEasyNumberTimer', value);
    }
  }

  Future<int> getSoloEasyNumberTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('soloEasyNumberTimer') ?? 0;
  }

  Future<void> setSoloMediumNumberTimer(int? value) async {
    if (value != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('soloMediumNumberTimer', value);
    }
  }

  Future<int> getSoloMediumNumberTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('soloMediumNumberTimer') ?? 0;
  }

  Future<void> setSoloHardNumberTimer(int? value) async {
    if (value != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('soloHardNumberTimer', value);
    }
  }

  Future<int> getSoloHardNumberTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('soloHardNumberTimer') ?? 0;
  }

  Future<void> setNumberGuessEasy(int? value) async {
    if (value != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('numberGuessEasy', value);
    }
  }

  Future<int> getNumberGuessEasy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('numberGuessEasy') ?? 0;
  }

  Future<void> setNumberGuessMedium(int? value) async {
    if (value != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('numberGuessMedium', value);
    }
  }

  Future<int> getNumberGuessMedium() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('numberGuessMedium') ?? 0;
  }

  Future<void> setNumberGuessHard(int? value) async {
    if (value != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('numberGuessHard', value);
    }
  }

  Future<int> getNumberGuessHard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('numberGuessHard') ?? 0;
  }
}
