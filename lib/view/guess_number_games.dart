import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(NumberGuessingGame());
}

class NumberGuessingGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int currentRound = 1; // Start at round 1
  int numberOfBoxes = 2; // Start with 2 boxes
  late List<int> boxNumbers;
  late List<bool> revealed; // Track whether numbers are revealed
  late List<Color> borderColors; // Track border colors for each box
  bool gameOver = false;
  String resultMessage = '';
  late List<int> numberPool;

  @override
  void initState() {
    super.initState();
    _generateBoxes();
  }

  void _generateBoxes() {
    Random random = Random();
    int correctIndex =
        random.nextInt(numberOfBoxes); // Random box contains the correct number
    boxNumbers = List.generate(
      numberOfBoxes,
      (index) => index == correctIndex
          ? currentRound // Correct number for this round
          : random.nextInt(9) + 1, // Other numbers between 1 and 10
    );
    revealed = List.generate(
        numberOfBoxes, (_) => false); // All boxes hidden initially
    borderColors = List.generate(
        numberOfBoxes, (_) => Colors.transparent); // No borders initially
  }

  void _handleTap(int tappedIndex) {
    if (gameOver) return;

    setState(() {
      revealed =
          List.generate(numberOfBoxes, (_) => true); // Reveal all numbers
      if (boxNumbers[tappedIndex] == currentRound) {
        borderColors[tappedIndex] = Colors.green; // Correct guess
        resultMessage = '✅ Correct! Moving to the next round...';

        // Progress to the next round after a delay
        Timer(Duration(seconds: 2), () {
          setState(() {
            if (currentRound == 10) {
              resultMessage = '🎉 Congratulations! You completed all rounds!';
              gameOver = true;
            } else {
              currentRound++;
              numberOfBoxes++;
              _generateBoxes();
              resultMessage =
                  'Round $currentRound: Find the number $currentRound!';
            }
          });
        });
      } else {
        borderColors[tappedIndex] = Colors.red; // Incorrect guess
        resultMessage = '❌ Incorrect! Try again in the next round.';
        gameOver = true;
      }
    });
  }

  void _resetGame() {
    setState(() {
      currentRound = 1;
      numberOfBoxes = 2;
      gameOver = false;
      resultMessage = '';
      _generateBoxes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Guessing Game'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            resultMessage.isEmpty
                ? 'Round $currentRound: Find the number $currentRound!'
                : resultMessage,
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: List.generate(numberOfBoxes, (index) {
              return GestureDetector(
                onTap: revealed[index] || gameOver
                    ? null // Disable tap if already revealed or game is over
                    : () => _handleTap(index),
                child: Container(
                  width: 80,
                  height: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: borderColors[
                          index], // Border color based on correctness
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue, // Background color
                  ),
                  child: Text(
                    revealed[index] ? 'Cick Me' : '${boxNumbers[index]}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
          ),
          if (gameOver)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: _resetGame,
                child: Text('Restart Game'),
              ),
            ),
        ],
      ),
    );
  }
}
