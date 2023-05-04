import 'package:flutter/material.dart';


class ArcCutOutContainer extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;
  final double? borderRadius;
  final double arcRadius;
  final bool isLeftSide;

  const ArcCutOutContainer({super.key,
    required this.child,
    required this.height,
    required this.width,
    required this.arcRadius,
    required this.isLeftSide, this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ArcCutOutClipper(arcRadius: arcRadius, isLeftSide: isLeftSide, borderRadius: borderRadius ?? 0),
      child: SizedBox(
        height: height,
        width: width,
        child: child,
      ),
    );
  }
}

class ArcCutOutClipper extends CustomClipper<Path> {
  final double arcRadius;
  final bool isLeftSide;
  final double borderRadius;


  ArcCutOutClipper({required this.arcRadius, required this.isLeftSide, this.borderRadius = 0});

  @override
  Path getClip(Size size) {
    final path = Path();
    if (isLeftSide) {
      path.moveTo(0, 0);
      path.arcToPoint(
        Offset(arcRadius, size.height / 2),
        radius: Radius.circular(arcRadius),
        clockwise: false,
      );
      path.arcToPoint(
        Offset(0, size.height),
        radius: Radius.circular(arcRadius),
        clockwise: false,
      );
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
    } else {
      path.moveTo(size.width - borderRadius, 0);
      // path.arcToPoint(
      //   Offset(size.width - arcRadius, size.height / 2),
      //   radius: Radius.circular(arcRadius),
      //   clockwise: false,
      // );

      // path.arcToPoint(
      //   Offset(size.width, size.height),
      //   radius: Radius.circular(arcRadius),
      //   clockwise: false,
      // );

      path.quadraticBezierTo(size.width - arcRadius - borderRadius, size.height / 2, size.width - borderRadius, size.height);
      // path.arcToPoint(
      //   Offset(size.width, size.height),
      //   radius: Radius.circular(arcRadius),
      //   clockwise: false,
      // );
      path.lineTo(0, size.height);
      path.lineTo(0, 0);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}