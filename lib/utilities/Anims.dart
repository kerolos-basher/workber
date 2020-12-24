import 'package:flutter/cupertino.dart';
import 'package:simple_animations/simple_animations.dart';

class Scale extends StatelessWidget {
  final int delayMilliseconds;
  final Widget child;
  final Playback playback;
  final int millisecondsDuration;
  final bool fade;
  final Curve curve;
  final double scalebegin;
  final double scaleend;
  final Alignment alignment;
  Scale({
    this.delayMilliseconds = 0,
    this.millisecondsDuration = 500,
    this.child,
    this.scalebegin = 0,
    this.scaleend = 1,
    this.curve = Curves.ease,
    this.fade = true,
    this.playback = Playback.PLAY_FORWARD,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("scale").add(Duration(milliseconds: (millisecondsDuration)),
          Tween(begin: scalebegin, end: scaleend),
          curve: curve)
    ]);

    return ControlledAnimation(
      delay: Duration(milliseconds: delayMilliseconds),
      playback: playback,
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Transform.scale(
        scale: animation["scale"],
        alignment: alignment,
        child: child,
        //offset: Offset(animation["translateX"], 0), child: child),
      ),
    );
  }
}