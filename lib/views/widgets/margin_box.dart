import 'package:flutter/material.dart';

class MarginBox extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;

  const MarginBox({
    super.key,
    required this.backgroundColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),

        Container(
          margin: const EdgeInsets.only(left: 6.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: child,
        ),
      ],
    );
  }
}
