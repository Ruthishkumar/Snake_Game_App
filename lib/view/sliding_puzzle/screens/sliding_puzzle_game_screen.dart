import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snake_game_app/utils/styles/app_colors.dart';

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  var numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
  int move = 0;

  static const duration = const Duration(seconds: 1);
  int secondsPassed = 0;
  bool isActive = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    numbers.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (timer == null) {
      timer = Timer.periodic(duration, (Timer t) {
        startTime();
      });
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: size.height,
          color: Colors.blue,
          child: Column(
            children: <Widget>[
              MyTitle(size),
              Grid(numbers, size, clickGrid),
              Menu(reset, move, secondsPassed, size),
            ],
          ),
        ),
      ),
    );
  }

  void clickGrid(index) {
    if (secondsPassed == 0) {
      isActive = true;
    }
    if (index - 1 >= 0 && numbers[index - 1] == 0 && index % 4 != 0 ||
        index + 1 < 16 && numbers[index + 1] == 0 && (index + 1) % 4 != 0 ||
        (index - 4 >= 0 && numbers[index - 4] == 0) ||
        (index + 4 < 16 && numbers[index + 4] == 0)) {
      setState(() {
        move++;
        numbers[numbers.indexOf(0)] = numbers[index];
        numbers[index] = 0;
      });
    }
    checkWin();
  }

  void startTime() {
    if (isActive) {
      setState(() {
        secondsPassed = secondsPassed + 1;
      });
    }
  }

  void reset() {
    setState(() {
      numbers.shuffle();
      move = 0;
      secondsPassed = 0;
      isActive = false;
    });
  }

  bool isSorted(List list) {
    int prev = list.first;
    for (var i = 1; i < list.length - 1; i++) {
      int next = list[i];
      if (prev > next) return false;
      prev = next;
    }
    return true;
  }

  void checkWin() {
    if (isSorted(numbers)) {
      isActive = false;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: Container(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "You Win!!",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 220.0,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Close",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    }
  }
}

class Grid extends StatelessWidget {
  var numbers = [];
  var size;
  Function clickGrid;

  Grid(this.numbers, this.size, this.clickGrid);

  @override
  Widget build(BuildContext context) {
    var height = size.height;

    return Container(
      height: height * 0.60,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
          ),
          itemCount: numbers.length,
          itemBuilder: (context, index) {
            return numbers[index] != 0
                ? GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      clickGrid(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.mineSweeperBgColor,
                          borderRadius: BorderRadius.all(Radius.circular(8.r))),
                      child: Center(child: Text("${numbers[index]}")),
                    ),
                  )
                : SizedBox.shrink();
            // return numbers[index] != 0
            //     ? GridButton("${numbers[index]}", () {
            //         clickGrid(index);
            //       })
            //     : SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class GridButton extends StatelessWidget {
  Function click;
  String text;

  GridButton(this.text, this.click);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        click();
      },
    );
  }
}

class Menu extends StatelessWidget {
  Function reset;
  int move;
  int secondsPassed;
  var size;

  Menu(this.reset, this.move, this.secondsPassed, this.size);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ResetButton(reset, "Reset"),
          Move(move),
          Time(secondsPassed),
        ],
      ),
    );
  }
}

class Move extends StatelessWidget {
  int move;

  Move(this.move);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Text(
        "Move: ${move}",
        style: TextStyle(
            color: Colors.white, decoration: TextDecoration.none, fontSize: 18),
      ),
    );
  }
}

class MyTitle extends StatelessWidget {
  var size;

  MyTitle(this.size);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.10,
      padding: EdgeInsets.all(5.0),
      child: Text(
        "Sliding Puzzle",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: size.height * 0.050,
            color: Colors.white,
            decoration: TextDecoration.none),
      ),
    );
  }
}

class ResetButton extends StatelessWidget {
  Function reset;
  String text;

  ResetButton(this.reset, this.text);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        reset();
      },
      // color: Colors.white,
      // shape: RoundedRectangleBorder(
      //   borderRadius: new BorderRadius.circular(30.0),
      // ),
      child: Text("Reset"),
    );
  }
}

class Time extends StatelessWidget {
  int secondsPassed;

  Time(this.secondsPassed);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Text(
        "Time: ${secondsPassed}",
        style: TextStyle(
          fontSize: 18,
          decoration: TextDecoration.none,
          color: Colors.white,
        ),
      ),
    );
  }
}
