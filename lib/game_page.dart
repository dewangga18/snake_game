import 'dart:async';
import 'dart:math';
import 'package:_snake_game/control_panel.dart';
import 'package:_snake_game/direction.dart';
import 'package:_snake_game/piece.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late int upperX, upperY, lowerX, lowerY;
  late double screenWidth, screenHeight;
  int step = 30;
  int len = 5;
  int score = 0;
  double speed = 1.0;
  Offset? foodPosition;
  late Piece food;
  List<Offset> positions = [];
  Direction direction = Direction.right;
  late Timer timer;

  void changeSpeed() {
    timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {});
    });
    if (timer.isActive) {
      timer.cancel();
    }
    timer = Timer.periodic(Duration(milliseconds: 400), (timer) {
      setState(() {});
    });
  }

  Widget getControl() {
    return ControlPanel(onTapped: (Direction newDirection) {
      direction = newDirection;
    });
  }

  Direction getRandomDirection() {
    int val = Random().nextInt(4);
    direction = Direction.values[val];
    return direction;
  }

  void restart() {
    len = 5;
    score = 0;
    speed = 1;
    positions = [];
    direction = getRandomDirection();
    changeSpeed();
  }

  @override
  void initState() {
    super.initState();
    restart();
  }

  int getNearest(int anum) {
    int output;
    output = (anum ~/ step) * step;
    if (output == 0) output += step;
    return output;
  }

  Offset getRandomPost() {
    Offset position;
    int posX = Random().nextInt(upperX) + lowerX;
    int posY = Random().nextInt(upperY) + lowerY;
    position = Offset(
      getNearest(posX).toDouble(),
      getNearest(posY).toDouble(),
    );
    return position;
  }

  void draw() async {
    if (positions.isEmpty) {
      positions.add((getRandomPost()));
    }

    while (len > positions.length) {
      positions.add(positions[positions.length - 1]);
    }

    for (var i = positions.length - 1; i > 0; i--) {
      positions[i] = positions[i - 1];
    }

    positions[0] = await getNextPost(positions[0]);
  }

  bool detectCollision(Offset position) {
    if (position.dx >= upperX && direction == Direction.right) {
      return true;
    } else if (position.dx <= lowerX && direction == Direction.left) {
      return true;
    } else if (position.dy >= upperY && direction == Direction.down) {
      return true;
    } else if (position.dy <= lowerY && direction == Direction.up) {
      return true;
    }

    return false;
  }

  void showGameOverDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.red,
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.blue, width: 3.0),
            ),
            title: const Text(
              'Game Over',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Your game is over but you played well, Your score is ${score.toString()}.',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  restart();
                },
                child: const Text(
                  'Restart',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<Offset> getNextPost(Offset post) async {
    late Offset nextPost;
    if (direction == Direction.right) {
      nextPost = Offset(post.dx + step, post.dy);
    } else if (direction == Direction.left) {
      nextPost = Offset(post.dx - step, post.dy);
    } else if (direction == Direction.up) {
      nextPost = Offset(post.dx, post.dy - step);
    } else if (direction == Direction.down) {
      nextPost = Offset(post.dx, post.dy + step);
    }

    if (detectCollision(post) == true) {
      if (timer.isActive) {
        timer.cancel();
      }
      await Future.delayed(
          const Duration(milliseconds: 200), () => showGameOverDialog());
      return post;
    }

    return nextPost;
  }

  void drawFood() {
    foodPosition ??= getRandomPost();
    if (foodPosition == positions[0]) {
      len++;
      score = score + 5;
      speed = speed + 0.25;
      foodPosition = getRandomPost();
    }
    food = Piece(
      posX: foodPosition!.dx.toInt(),
      posY: foodPosition!.dy.toInt(),
      size: step,
      isAnimated: true,
      colors: Colors.white,
    );
  }

  List<Piece> getPieces() {
    final pieces = <Piece>[];
    draw();
    drawFood();

    for (var i = 0; i < len; i++) {
      if (i >= positions.length) {
        continue;
      }
      pieces.add(Piece(
          posX: positions[i].dx.toInt(),
          posY: positions[i].dy.toInt(),
          size: step,
          isAnimated: false,
          colors: i.isEven ? Colors.black.withOpacity(0.5) : Colors.black));
    }
    return pieces;
  }

  Widget getScore() {
    return Positioned(
      top: 40.0,
      right: 30.0,
      child: Text(
        'Score : ${score.toString()}',
        style: const TextStyle(fontSize: 30, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    lowerY = step;
    lowerX = step;
    upperY = getNearest(screenHeight.toInt() - step);
    upperX = getNearest(screenWidth.toInt() - step);
    return Scaffold(
      body: Container(
        color: Colors.indigo.withOpacity(0.7),
        child: Stack(
          children: [
            Stack(children: getPieces()),
            getControl(),
            food,
            getScore()
          ],
        ),
      ),
    );
  }
}
