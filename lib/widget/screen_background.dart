import 'package:flutter/material.dart';
import '../style/style.dart';

class ScreenBackground extends StatelessWidget {
  final Widget child;

  const ScreenBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        screenBackground(context),
        child,
      ],
    );
  }
}
