import 'package:flutter/material.dart';

class NumberScreenProvider extends ChangeNotifier {
  int getEasyHighScore = 0;
  int getMediumHighScore = 0;
  int getHardHighScore = 0;

  void addEasyHighScore(int value) {
    getEasyHighScore = value;
    notifyListeners();
  }

  void addMediumHighScore(int value) {
    getMediumHighScore = value;
    notifyListeners();
  }

  void addHardHighScore(int value) {
    getHardHighScore = value;
    notifyListeners();
  }
}
