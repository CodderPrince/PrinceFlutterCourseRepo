import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(SnakeGame());
}

class SnakeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake Game',
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const int tileSize = 40;
  static const int width = 20;
  static const int height = 20;
  static const int gameSpeed = 130;

  List<Point> snake = [];
  Point? food;
  Timer? timer;
  Direction currentDirection = Direction.right;
  bool gameOver = false;
  int score = 0;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    setState(() {
      snake = [Point(width ~/ 2, height ~/ 2)];
      currentDirection = Direction.right;
      gameOver = false;
      score = 0;
      spawnFood();
    });
    timer = Timer.periodic(Duration(milliseconds: gameSpeed), (Timer t) => run());
  }

  void run() {
    if (gameOver) {
      timer?.cancel();
      return;
    }

    setState(() {
      update();
    });
  }

  void update() {
    var newHead = snake.first.move(currentDirection);

    if (newHead.x < 0 || newHead.x >= width || newHead.y < 0 || newHead.y >= height || snake.contains(newHead)) {
      gameOver = true;
    } else {
      snake.insert(0, newHead);
      if (newHead == food) {
        score += 5;
        spawnFood();
      } else {
        snake.removeLast();
      }
    }
  }

  void spawnFood() {
    do {
      food = Point(random.nextInt(width), random.nextInt(height));
    } while (snake.contains(food));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0 && currentDirection != Direction.up) {
                  currentDirection = Direction.down;
                } else if (details.delta.dy < 0 && currentDirection != Direction.down) {
                  currentDirection = Direction.up;
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0 && currentDirection != Direction.left) {
                  currentDirection = Direction.right;
                } else if (details.delta.dx < 0 && currentDirection != Direction.right) {
                  currentDirection = Direction.left;
                }
              },
              child: GridView.builder(
                itemCount: width * height,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: width),
                itemBuilder: (BuildContext context, int index) {
                  var color;
                  int x = index % width;
                  int y = index ~/ width;

                  if (snake.contains(Point(x, y))) {
                    color = Colors.green[500];
                  } else if (food != null && food == Point(x, y)) {
                    color = Colors.red;
                  } else {
                    color = Colors.grey[800];
                  }

                  return Container(
                    margin: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Text(
                gameOver ? "Game Over! Score: $score" : "Score: $score",
                style: TextStyle(color: Colors.white, fontSize: 40),
              ),
            ),
          ),
          gameOver
              ? TextButton(
            child: Text("Play Again", style: TextStyle(fontSize: 20)),
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.blue,
            ),
            onPressed: () {
              startGame();
            },
          )
              : Container(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}

enum Direction { up, down, left, right }

class Point {
  final int x, y;

  Point(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Point && runtimeType == other.runtimeType && x == other.x && y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  Point move(Direction direction) {
    switch (direction) {
      case Direction.up:
        return Point(x, y - 1);
      case Direction.down:
        return Point(x, y + 1);
      case Direction.left:
        return Point(x - 1, y);
      case Direction.right:
        return Point(x + 1, y);
    }
    throw Exception("Invalid direction");
  }
}
