import 'package:flutter/material.dart';

void main() {
  runApp(DotsAndBoxesApp());
}

class DotsAndBoxesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dots and Boxes',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DotsAndBoxesGame(),
    );
  }
}

class DotsAndBoxesGame extends StatefulWidget {
  @override
  _DotsAndBoxesGameState createState() => _DotsAndBoxesGameState();
}

class _DotsAndBoxesGameState extends State<DotsAndBoxesGame> {
  final int gridSize = 4; // Adjust for larger grids
  List<List<int>> horizontalLines = [];
  List<List<int>> verticalLines = [];
  List<List<int>> boxes = [];
  bool isBlueTurn = true;

  // Track the last tapped dot
  Offset? lastDot;

  @override
  void initState() {
    super.initState();
    horizontalLines =
        List.generate(gridSize, (_) => List.filled(gridSize - 1, 0));
    verticalLines =
        List.generate(gridSize - 1, (_) => List.filled(gridSize, 0));
    boxes = List.generate(gridSize - 1, (_) => List.filled(gridSize - 1, 0));
  }

  void handleDotTap(int row, int col) {
    if (lastDot == null) {
      // Store the first tapped dot
      lastDot = Offset(row.toDouble(), col.toDouble());
    } else {
      // Determine the line orientation based on the last dot and the current tap
      int lastRow = lastDot!.dx.toInt();
      int lastCol = lastDot!.dy.toInt();

      if ((row - lastRow).abs() + (col - lastCol).abs() == 1) {
        // Adjacent dots
        if (row == lastRow) {
          // Horizontal line
          int lineIndex = col > lastCol ? lastCol : col;
          if (horizontalLines[row][lineIndex] == 0) {
            setState(() {
              horizontalLines[row][lineIndex] = isBlueTurn ? 1 : 2;
              isBlueTurn = !isBlueTurn;
            });
          }
        } else if (col == lastCol) {
          // Vertical line
          int lineIndex = row > lastRow ? lastRow : row;
          if (verticalLines[lineIndex][col] == 0) {
            setState(() {
              verticalLines[lineIndex][col] = isBlueTurn ? 1 : 2;
              isBlueTurn = !isBlueTurn;
            });
          }
        }
      }
      lastDot = null; // Reset last dot after a valid move
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dots and Boxes"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              isBlueTurn ? "Blue's Turn" : "Red's Turn",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
      body: Center(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridSize * 2 - 1,
          ),
          itemCount: (gridSize * 2 - 1) * (gridSize * 2 - 1),
          itemBuilder: (context, index) {
            int row = index ~/ (gridSize * 2 - 1);
            int col = index % (gridSize * 2 - 1);

            if (row % 2 == 0 && col % 2 == 0) {
              // Dot
              return GestureDetector(
                onTap: () => handleDotTap(row ~/ 2, col ~/ 2),
                child: Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            } else if (row % 2 == 0) {
              // Horizontal line
              int lineIndex = col ~/ 2;
              return Container(
                color: horizontalLines[row ~/ 2][lineIndex] == 0
                    ? Colors.grey[300]
                    : (horizontalLines[row ~/ 2][lineIndex] == 1
                        ? Colors.blue
                        : Colors.red),
              );
            } else if (col % 2 == 0) {
              // Vertical line
              int lineIndex = row ~/ 2;
              return Container(
                color: verticalLines[lineIndex][col ~/ 2] == 0
                    ? Colors.grey[300]
                    : (verticalLines[lineIndex][col ~/ 2] == 1
                        ? Colors.blue
                        : Colors.red),
              );
            } else {
              // Box
              int boxRow = row ~/ 2;
              int boxCol = col ~/ 2;
              return Container(
                color: boxes[boxRow][boxCol] == 0
                    ? Colors.white
                    : (boxes[boxRow][boxCol] == 1 ? Colors.blue : Colors.red),
              );
            }
          },
        ),
      ),
    );
  }
}
