import 'dart:async';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:frontend/features/adventure_runner/componenets/background/horizon.dart';

enum GameState { playing, intro, gameOver }

class RunnerGame extends FlameGame
    with KeyboardEvents, TapDetector, HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xFFFFFFFF);

  int _score = 0;
  int _speed = 0;
  int _highscore = 0;
  int get score => _score;

  num get speed => _speed;

  String scoreString(int score) => score.toString().padLeft(5, '0');

  /// Used for score calculation
  double _distanceTraveled = 0;

  GameState state = GameState.intro;
  double currentSpeed = 0.0;
  double timePlaying = 0.0;

  final double acceleration = 5;
  final double characterAcceleration = 0.005;
  final double maxSpeed = 2500.0;
  final double startSpeed = 300;

  bool get isPlaying => state == GameState.playing;
  bool get isGameOver => state == GameState.gameOver;
  bool get isIntro => state == GameState.intro;

  @override
  Future<void> onLoad() async {
    await Flame.images.loadAll([
      "/main_characters/mask_dude/Hit (32x32).png",
      "/main_characters/mask_dude/Idle (32x32).png",
      "/main_characters/mask_dude/Jump (32x32).png",
      "/main_characters/mask_dude/Run (32x32).png",
      "/main_characters/mask_dude/Double Jump (32x32).png",
      "tiles/tile.png",
      "parallax/hills&trees.png",
      "parallax/ruins_bg.png",
      "parallax/ruins.png",
      "parallax/sky.png",
      "parallax/statue.png",
      "parallax/stones&grass.png",
    ]);
    add(Horizon());
    return super.onLoad();
  }
}
