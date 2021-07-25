import 'package:flutter/animation.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class AnimationSequences {
  AnimationSequences({required this.controler});
  final AnimationController controler;
  late SequenceAnimationBuilder _animation;
  SequenceAnimationBuilder create() {
    return _animation = new SequenceAnimationBuilder();
  }

  void addAnimated(Animatable<dynamic> animatable, Duration from, Duration to,
      String tag, Curve curve) {
    _animation.addAnimatable(
        animatable: animatable, from: from, to: to, tag: tag, curve: curve);
  }

  void buid() {
    _animation.animate(controler);
  }

  dynamic getValueTag(String tag) {
    return _animation.animate(controler)[tag].value;
  }
}
