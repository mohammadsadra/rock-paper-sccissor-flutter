import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:rps/image.dart';

void main() => runApp(const RockPaperScissorsApp());

class RockPaperScissorsApp extends StatelessWidget {
  const RockPaperScissorsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rock Paper Scissors',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      debugShowCheckedModeBanner: false,
      home: const RockPaperScissorsScreen(),
    );
  }
}

class RockPaperScissorsScreen extends StatefulWidget {
  const RockPaperScissorsScreen({super.key});

  @override
  _RockPaperScissorsScreenState createState() =>
      _RockPaperScissorsScreenState();
}

class _RockPaperScissorsScreenState extends State<RockPaperScissorsScreen> {
  List<RPSObject> objects = [];
  Random random = Random();
  bool isStarted = false;

  @override
  void initState() {
    super.initState();
    createObjects();
  }

  // Creating objects
  void createObjects() {
    for (int i = 0; i < 5; i++) {
      objects.add(RPSObject(type: RPSObjectType.Rock));
      objects.add(RPSObject(type: RPSObjectType.Paper));
      objects.add(RPSObject(type: RPSObjectType.Scissors));
    }
  }

  //Move objects
  void moveObjects() {
    setState(() {
      for (var object in objects) {
        object.move();
      }
    });
  }

  // Check is two object has collision
  void checkCollisions() {
    setState(() {
      for (int i = 0; i < objects.length - 1; i++) {
        for (int j = i + 1; j < objects.length; j++) {
          if (objects[i].isCollidingWith(objects[j])) {
            handleCollision(objects[i], objects[j]);
          }
        }
      }
    });
  }

  // Handling collisions
  void handleCollision(RPSObject object1, RPSObject object2) {
    if (object1.type == object2.type) {
      object1.redirect();
      object2.redirect();
    } else {
      RPSObjectType winnerType = getWinner(object1.type, object2.type);
      if (winnerType == object1.type) {
        objects.remove(object2);
        object1.redirect();
      } else {
        objects.remove(object1);
        object2.redirect();
      }
    }
  }

  // Cheking winner of collision
  RPSObjectType getWinner(RPSObjectType type1, RPSObjectType type2) {
    if ((type1 == RPSObjectType.Rock && type2 == RPSObjectType.Scissors) ||
        (type1 == RPSObjectType.Scissors && type2 == RPSObjectType.Paper) ||
        (type1 == RPSObjectType.Paper && type2 == RPSObjectType.Rock)) {
      return type1;
    } else {
      return type2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rock Paper Scissors'),
        actions: [
          !isStarted
              ? TextButton(
                  onPressed: () {
                    const duration = Duration(milliseconds: 40);
                    Timer.periodic(duration, (timer) {
                      moveObjects();
                      checkCollisions();
                      setState(() {
                        isStarted = true;
                      });
                    });
                  },
                  child: const Text(
                    'Start',
                    style: TextStyle(color: Colors.white),
                  ))
              : Container(),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            for (var object in objects)
              Positioned(
                left: object.x,
                top: object.y,
                child: Container(
                  width: object.size,
                  height: object.size,
                  color: Colors.transparent,
                  child: object.getImage(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum RPSObjectType { Rock, Paper, Scissors }

class RPSObject {
  // X and Y are postions
  // directionX and directionY is direction that they want to move
  RPSObjectType type;
  double x = 0;
  double y = 0;
  double size = 0;
  double directionX = 0;
  double directionY = 0;
  Random random = Random();

  double width = Get.width;
  // -50 is for Noth in iPhones
  
  double height = Get.height - AppBar().preferredSize.height - 50;

  // Initialize object
  RPSObject({required this.type}) {
    size = 50.0;
    x = random.nextDouble() * (width - size);
    y = random.nextDouble() * (height - size);
    directionX = random.nextBool() ? 1.0 : -1.0;
    directionY = random.nextBool() ? 1.0 : -1.0;
  }

  // Move object
  void move() {
    x += directionX * 5;
    y += directionY * 5;

    if (x < 0 || x > width - size) {
      directionX *= -1;
    }

    if (y < 0 || y > height - size) {
      directionY *= -1;
    }
  }

  // Checking is colliding with other object
  bool isCollidingWith(RPSObject other) {
    return x < other.x + other.size &&
        x + size > other.x &&
        y < other.y + other.size &&
        y + size > other.y;
  }

  // If has collisio, change the directions
  void redirect() {
    directionX *= -1;
    directionY *= 1;
  }

  // Get image of object
  Image getImage() {
    switch (type) {
      case RPSObjectType.Rock:
        return const Image(
          image: AssetImage(rock),
        );
      case RPSObjectType.Paper:
        return const Image(
          image: AssetImage(paper),
        );
      case RPSObjectType.Scissors:
        return const Image(
          image: AssetImage(scissor),
        );
      default:
        return const Image(
          image: AssetImage(rock),
        );
    }
  }
}
