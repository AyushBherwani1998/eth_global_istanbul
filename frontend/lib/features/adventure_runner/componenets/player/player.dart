import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:frontend/features/adventure_runner/adventure_runner.dart';

enum PlayerState { crashed, jumping, running, waiting, slipped }

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameReference<AdventureRunner>, CollisionCallbacks {
  Player() : super(size: Vector2.all(64));

  final double gravity = 1;

  final double initialJumpVelocity = -15.0;
  late final double startXPosition;

  double _jumpVelocity = 0.0;

  double get groundYPos {
    return game.size.y - height / 2 - 58;
  }

  @override
  Future<void> onLoad() async {
    startXPosition = game.size.x / 2.5 - 200;
    add(CircleHitbox());

    animations = {
      PlayerState.running: _spriteAnimation("Run", 12),
      PlayerState.waiting: _spriteAnimation("Idle", 11),
      PlayerState.jumping: _spriteAnimation("Jump", 1),
      PlayerState.crashed: _spriteAnimation("Hit", 7),
      PlayerState.slipped: _spriteAnimation("Double Jump", 6)
    };

    current = PlayerState.waiting;
  }

  void jump(double speed) {
    if (current == PlayerState.jumping) {
      return;
    }

    FlameAudio.play('jump.wav', volume: 1.0);

    current = PlayerState.jumping;
    _jumpVelocity = initialJumpVelocity - (speed / 500);
  }

  void reset() {
    y = groundYPos;
    _jumpVelocity = 0.0;
    current = PlayerState.running;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (current == PlayerState.jumping) {
      y += _jumpVelocity;
      _jumpVelocity += gravity;
      if (y > groundYPos) {
        reset();
      }
    } else {
      y = groundYPos;
    }

    if (game.isIntro && x < startXPosition) {
      x += startXPosition;
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    y = groundYPos;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    game.gameOver();
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('/main_characters/mask_dude/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.08,
        textureSize: Vector2.all(32),
      ),
    );
  }
}
