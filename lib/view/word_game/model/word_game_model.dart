import 'dart:developer' as dev;
import 'dart:math';

import 'package:arcade_game/view/word_game/model/word_letter_model.dart';

class WordGameModel {
  int rowId = 0;
  int letterId = 0;
  static String gameMessage = "";
  static String gameGuess = "";
  static List<String> gameWordList = [
    "world",
    "fight",
    "brain",
    "plane",
    "earth",
    "robot",
  ];
  static bool gameOver = false;
  //setting the game row
  static List<WordLetterModel> wordGameRow = List.generate(
    5,
    (index) => WordLetterModel("", 0),
  );

  /// Setting the gameBoard
  List<List<WordLetterModel>> wordBoard = List.generate(
      5, (index) => List.generate(5, (index) => WordLetterModel("", 0)));

  /// Setting the Game Function
  void passTry() {
    rowId++;
    letterId = 0;
  }

  static void initGame() {
    final random = Random();
    int index = random.nextInt(gameWordList.length);
    gameGuess = 'plane'.toUpperCase();
    dev.log('Init Game Guess ${gameGuess}');
  }

  /// Setting the game insertion
  void insertWord(index, word) {
    wordBoard[rowId][index] = word;
  }

  /// checking world
  bool checkWordExist(String word) {
    return gameWordList.contains(word);
  }
}
