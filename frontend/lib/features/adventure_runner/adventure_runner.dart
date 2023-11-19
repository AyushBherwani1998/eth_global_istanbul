import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/features/adventure_runner/componenets/background/horizon.dart';
import 'package:frontend/features/adventure_runner/componenets/background/parallax.dart';
import 'package:frontend/features/adventure_runner/componenets/home_button.dart';
import 'package:frontend/features/adventure_runner/componenets/player/player.dart';
import 'package:google_fonts/google_fonts.dart';

enum GameState { playing, intro, gameOver }

class AdventureRunner extends FlameGame
    with KeyboardEvents, TapDetector, HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xFFFFFFFF);

  int _score = 0;
  int _speed = 0;
  int _highscore = 0;

  late final TextComponent scoreText;
  late final TextComponent speedText;
  final ParallaxBackground parallax = ParallaxBackground();
  final Player player = Player();

  int get score => _score;

  num get speed => _speed;

  set speed(num currentSped) {
    _speed = currentSped.toInt();
    speedText.text = "Speed: $speed";
  }

  String scoreString(int score) => score.toString().padLeft(5, '0');

  /// Used for score calculation
  double _distanceTraveled = 0;

  GameState state = GameState.intro;
  double currentSpeed = 0.0;
  double timePlaying = 0.0;

  final double acceleration = 5;
  final double characterAcceleration = 0.1;
  final double maxSpeed = 2500.0;
  final double startSpeed = 300;

  bool get isPlaying => state == GameState.playing;
  bool get isGameOver => state == GameState.gameOver;
  bool get isIntro => state == GameState.intro;

  set score(int newScore) {
    _score = newScore;
    scoreText.text = scoreString(_score);
  }

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
      "HUD/Home.png",
    ]);

    add(parallax);
    add(player);
    add(Horizon());
    add(HomeButton());

    scoreText = TextComponent(
      position: Vector2(20, 20),
      textRenderer: TextPaint(
        style: GoogleFonts.pressStart2p(fontSize: 24),
      ),
    );

    speedText = TextComponent(
      text: startSpeed.toInt().toString(),
      textRenderer: TextPaint(
        style: GoogleFonts.pressStart2p(fontSize: 24),
      ),
    );

    add(scoreText);

    score = 0;

    return super.onLoad();
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (keysPressed.contains(LogicalKeyboardKey.enter) ||
        keysPressed.contains(LogicalKeyboardKey.space)) {
      onAction();
    }
    return KeyEventResult.handled;
  }

  @override
  void onTapDown(TapDownInfo info) {
    onAction();
  }

  void onAction() {
    if (isGameOver || isIntro) {
      restart();
      return;
    }
    player.jump(currentSpeed);
  }

  void gameOver() {
    state = GameState.gameOver;
    player.current = PlayerState.crashed;
    currentSpeed = 0.0;
  }

  void restart() {
    state = GameState.playing;
    player.reset();

    currentSpeed = startSpeed;

    timePlaying = 0.0;
    if (score > _highscore) {
      _highscore = score;
    }
    score = 0;
    _distanceTraveled = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) {
      parallax.stopMoving();
      return;
    }

    speedText.position = Vector2(size.x - speedText.width - 20, 20);

    if (isPlaying) {
      timePlaying += dt;
      _distanceTraveled += dt * currentSpeed;
      score = _distanceTraveled ~/ 50;

      if (currentSpeed < maxSpeed) {
        currentSpeed += acceleration * dt;
        speed = currentSpeed;

        if (parallax.xDistance <= 0 && parallax.xDistance < currentSpeed) {
          parallax.startMoving(currentSpeed);
        }
      }
    }
  }
}
