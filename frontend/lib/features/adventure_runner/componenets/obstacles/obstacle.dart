import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

import 'dart:math';

import 'package:frontend/features/adventure_runner/adventure_runner.dart';
import 'package:frontend/features/adventure_runner/componenets/obstacles/obstacle_type.dart';

final random = Random();

extension RandomExtension on Random {
  double fromRange(double min, double max) =>
      (nextDouble() * (max - min + 1)).floor() + min;
}

class Obstacle extends SpriteAnimationComponent
    with HasGameReference<AdventureRunner> {
  Obstacle({
    required this.settings,
    required this.groupIndex,
  }) : super(size: settings.size);

  final double _gapCoefficient = 0.6;
  final double _maxGapCoefficient = 1.5;

  bool followingObstacleCreated = false;
  late double gap;
  final ObstacleTypeSettings settings;
  final int groupIndex;

  bool get isVisible => (x + width) > 0;

  Future<SpriteAnimation> spriteAnimation() async {
    if (settings.type == ObstacleType.saw) {
      return await game.loadSpriteAnimation(
        "obstacles/saw.png",
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.2,
          textureSize: Vector2.all(38),
        ),
      );
    }
    return await game.loadSpriteAnimation(
      'obstacles/head_banana.png',
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 0.2,
        textureSize: Vector2.all(32),
      ),
    );
  }

  @override
  Future<void> onLoad() async {
    animation = await spriteAnimation();
    scale = settings.scale;
    x = game.size.x + width * groupIndex;
    y = game.size.y / 2 - 74;
    gap = computeGap(_gapCoefficient, game.currentSpeed);
    addAll(settings.generateHitboxes());
  }

  double computeGap(double gapCoefficient, double speed) {
    final minGap =
        (width * speed * settings.minGap * gapCoefficient).roundToDouble();
    final maxGap = (minGap * _maxGapCoefficient).roundToDouble();
    return random.fromRange(minGap, maxGap);
  }

  @override
  void update(double dt) {
    super.update(dt);
    x -= game.currentSpeed * dt;

    if (!isVisible) {
      removeFromParent();
    }
  }
}
