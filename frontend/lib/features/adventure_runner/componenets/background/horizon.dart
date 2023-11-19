import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:frontend/features/adventure_runner/adventure_runner.dart';
import 'package:frontend/features/adventure_runner/componenets/obstacles/obstacle_manager.dart';

class Horizon extends PositionComponent with HasGameReference<AdventureRunner> {
  Horizon() : super();

  static final Vector2 lineSize = Vector2(64, 32);
  final Queue<SpriteComponent> groundLayers = Queue();
  final ObstacleManager obstacleManager = ObstacleManager();

  late final _tileSprite = Sprite(
    game.images.fromCache("tiles/tile.png"),
    srcSize: Vector2.all(32),
  );

  @override
  Future<void> onLoad() async {
    add(obstacleManager);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final increment = game.currentSpeed * dt;
    for (final line in groundLayers) {
      line.x -= increment;
    }

    final firstLine = groundLayers.first;
    if (firstLine.x <= -firstLine.width) {
      firstLine.x = groundLayers.last.x + groundLayers.last.width;
      groundLayers.remove(firstLine);
      groundLayers.add(firstLine);
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    final newLines = _generateLines();
    groundLayers.addAll(newLines);
    addAll(newLines);
    y = (size.y / 2) + 21.0;
  }

  void reset() {
    groundLayers.forEachIndexed((i, line) => line.x = i * lineSize.x);
    obstacleManager.reset();
  }

  List<SpriteComponent> _generateLines() {
    final number = 1 + (game.size.x / lineSize.x).ceil() - groundLayers.length;
    final lastX = (groundLayers.lastOrNull?.x ?? 0) +
        (groundLayers.lastOrNull?.width ?? 0);
    return List.generate(
      max(number.toInt(), 0),
      (i) => SpriteComponent(
        sprite: _tileSprite,
        size: lineSize,
      )
        ..x = lastX + lineSize.x * i
        ..y = game.size.y / 2 - 48,
      growable: false,
    );
  }
}
