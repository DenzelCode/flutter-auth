import 'package:flutter/material.dart';

class CirclesBackground extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color topSmallCircleColor;
  final Color topMediumCircleColor;
  final Color topRightCircleColor;
  final Color bottomRightCircleColor;

  const CirclesBackground({
    Key? key,
    required this.child,
    required this.backgroundColor,
    required this.topSmallCircleColor,
    required this.topMediumCircleColor,
    required this.topRightCircleColor,
    required this.bottomRightCircleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: backgroundColor),
      child: Stack(
        children: [
          Positioned(
            top: -16,
            left: 235,
            child: _CircularBox(
              width: 398,
              height: 398,
              color: topRightCircleColor,
            ),
          ),
          Positioned(
            top: -412,
            left: -184,
            child: _CircularBox(
              width: 700,
              height: 700,
              color: topMediumCircleColor,
            ),
          ),
          Positioned(
            top: -292,
            left: -163,
            child: _CircularBox(
              width: 398,
              height: 398,
              color: topSmallCircleColor,
            ),
          ),
          Positioned(
            top: size.height - (459 / 2),
            left: size.width - (459 / 2),
            child: _CircularBox(
              width: 459,
              height: 459,
              color: bottomRightCircleColor,
            ),
          ),
          SafeArea(child: this.child),
        ],
      ),
    );
  }
}

class _CircularBox extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const _CircularBox({
    Key? key,
    required this.width,
    required this.height,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height),
      ),
    );
  }
}
