import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/adventure_levels/adventure_levels.dart';

class HomeButton extends SpriteComponent
    with HasGameRef<AdventureLevels>, TapCallbacks {
  HomeButton();

  final margin = 32;
  final buttonSize = 64;

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('HUD/Home.png'));
    position = Vector2(game.size.x - 64, 20);
    priority = 10;
    scale = Vector2.all(2);
    return super.onLoad();
  }

  void closeGame() {
    Navigator.pop(gameRef.buildContext!);
  }

  @override
  void onTapDown(TapDownEvent event) {
    closeGame();
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    closeGame();
    super.onTapUp(event);
  }
}
