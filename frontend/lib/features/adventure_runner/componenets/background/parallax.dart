import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

class ParallaxBackground extends ParallaxComponent with KeyboardHandler {
  double xDistance = 0;

  @override
  Future<void> onLoad() async {
    final imageNames = [
      ParallaxImageData('parallax/sky.png'),
      ParallaxImageData('parallax/ruins_bg.png'),
      ParallaxImageData('parallax/hills&trees.png'),
      ParallaxImageData('parallax/ruins.png'),
      ParallaxImageData('parallax/ruins2.png'),
      ParallaxImageData('parallax/stones&grass.png'),
      ParallaxImageData('parallax/statue.png'),
    ];

    parallax = await Parallax.load(
      imageNames,
      baseVelocity: Vector2.zero(),
      filterQuality: FilterQuality.none,
    );
    anchor = Anchor.topLeft;
  }

  @override
  void update(double dt) {
    parallax?.baseVelocity = Vector2(xDistance, 0);
    super.update(dt);
  }

  void startMoving(double velcoity) {
    xDistance = velcoity;
  }

  void stopMoving() {
    xDistance = 0;
  }
}
