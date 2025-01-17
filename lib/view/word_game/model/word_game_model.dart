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
    "Apple",
    "Arrow",
    "Beach",
    "Bench",
    "Birch",
    "Block",
    "Blaze",
    "Bread",
    "Brush",
    "Chair",
    "Chalk",
    "Chest",
    "Clear",
    "Clock",
    "Cloud",
    "Crane",
    "Creek",
    "Crown",
    "Dance",
    "Daisy",
    "Diver",
    "Drift",
    "Eagle",
    "Earth",
    "Empty",
    "Fence",
    "Field",
    "Flame",
    "Flash",
    "Floor",
    "Flour",
    "Frame",
    "Frost",
    "Fruit",
    "Glass",
    "Globe",
    "Grass",
    "Grain",
    "Grant",
    "Grove",
    "Guide",
    "Happy",
    "Heart",
    "Horse",
    "House",
    "Human",
    "Jelly",
    "Jewel",
    "Jolly",
    "Juicy",
    "Knife",
    "Light",
    "Limit",
    "Lucky",
    "Maple",
    "Match",
    "Metal",
    "Minor",
    "Mouse",
    "Mount",
    "Music",
    "Novel",
    "Oasis",
    "Olive",
    "Organ",
    "Paint",
    "Paper",
    "Petal",
    "Plant",
    "Plate",
    "Point",
    "Power",
    "Pride",
    "Quiet",
    "Raise",
    "Range",
    "River",
    "Round",
    "Rural",
    "Scale",
    "Scare",
    "Scene",
    "Scope",
    "Sheep",
    "Shine",
    "Shore",
    "Smart",
    "Smile",
    "Sound",
    "Space",
    "Stone",
    "Storm",
    "Story",
    "Taste",
    "Voice",
  ];
  static bool gameOver = false;
  //setting the game row
  static List<WordLetterModel> wordGameRow = List.generate(
    100,
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
    final random = new Random();
    int index = random.nextInt(gameWordList.length);
    gameGuess = gameWordList[index].toUpperCase();
    dev.log('Init Game Guess ${gameGuess}');
    // final random = Random();
    // int index = random.nextInt(gameWordList.length);
    // gameGuess = 'plane'.toUpperCase();
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
