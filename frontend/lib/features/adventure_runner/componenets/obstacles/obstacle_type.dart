import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum ObstacleType {
  headBanana,
  saw,
}

class ObstacleTypeSettings {
  const ObstacleTypeSettings._internal(
    this.type, {
    required this.size,
    required this.y,
    required this.allowedAt,
    required this.multipleAt,
    required this.minGap,
    required this.minSpeed,
    required this.generateHitboxes,
    required this.scale,
  });

  final ObstacleType type;
  final Vector2 size;
  final double y;
  final int allowedAt;
  final int multipleAt;
  final double minGap;
  final double minSpeed;
  final Vector2 scale;

  static const maxGroupSize = 3.0;

  final List<ShapeHitbox> Function() generateHitboxes;

  static final saw = ObstacleTypeSettings._internal(
    ObstacleType.saw,
    size: Vector2.all(38),
    y: 224,
    allowedAt: 400,
    multipleAt: 1000,
    minGap: 120.0,
    minSpeed: 0.0,
    scale: Vector2.all(1.5),
    generateHitboxes: () => <ShapeHitbox>[
      RectangleHitbox(
        collisionType: CollisionType.passive,
        size: Vector2.all(18),
      ),
    ],
  );

  static final headBanana = ObstacleTypeSettings._internal(
    ObstacleType.headBanana,
    size: Vector2.all(32),
    y: 224,
    allowedAt: 0,
    multipleAt: 400,
    minGap: 120.0,
    minSpeed: 0.0,
    scale: Vector2.all(1),
    generateHitboxes: () => <ShapeHitbox>[
      RectangleHitbox(
        collisionType: CollisionType.passive,
        size: Vector2.all(18),
      ),
    ],
  );
}
