import 'package:flutter/cupertino.dart';

class WordGameProvider extends ChangeNotifier {
  bool gameOver = false;

  void addGameOver(bool value) {
    gameOver = value;
    notifyListeners();
  }
}
