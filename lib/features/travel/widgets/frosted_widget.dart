import 'dart:ui';
import 'package:flutter/material.dart';

class FrostedWidget extends StatelessWidget {
  final Widget child;
  final Color color;

  const FrostedWidget({
    super.key,
    required this.child,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(60),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          alignment: Alignment.center,
          color: color,
          child: child,
        ),
      ),
    );
  }
}
