import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class AnimatedTextkit extends StatelessWidget {
  final AnimatedText widget;
  final bool isRepeat;

  const AnimatedTextkit({
    super.key,
    required this.widget,
    required this.isRepeat,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        widget,
      ],
      repeatForever: isRepeat,
    );
  }
}
