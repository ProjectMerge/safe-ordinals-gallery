import 'package:flutter/material.dart';

class BackgroundWidget extends StatefulWidget {
  final bool mainMenu;
  final bool hasImage;
  final bool splash;
  final String? image;
  final bool arc;
  final String title;

  const BackgroundWidget({Key? key, this.mainMenu = false, this.hasImage = true, this.image, this.arc = false, this.splash = false, this.title = ""}) : super(key: key);

  @override
  BackgroundWidgetState createState() => BackgroundWidgetState();
}

class BackgroundWidgetState extends State<BackgroundWidget> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Container(
            width: width,
            height: height,
            decoration: const BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFC7C6EF),
                  Color(0xFFE5D3DA)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class WavePainter extends CustomPainter {
  final Color color1;
  final Color color2;

  WavePainter(this.color1, this.color2);

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    Path path = Path()
      ..moveTo(0, height * 0.75)
      ..quadraticBezierTo(width / 4, height, width / 2, height * 0.73)
      ..quadraticBezierTo(width * 3 / 4, height / 2, width, height * 0.80)
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();

    Path path2 = Path()
      ..moveTo(0, height * 0.69)
      ..quadraticBezierTo(width / 4, height, width / 2, height * 0.78)
      ..quadraticBezierTo(width * 3 / 4, height / 2, width, height * 0.78)
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();

    // Path path3 = Path()
    //   ..moveTo(0, height * 0.69)
    //   ..quadraticBezierTo(width / 4, height/2, width * 0.45, height * 0.66)
    //   ..lineTo(width, height)
    //   ..lineTo(0, height)
    //   ..close();

    Path pathShadow = Path()
      ..moveTo(-10, height * 0.70)
      ..quadraticBezierTo(width / 4, height, width / 2, height * 0.75)
      ..quadraticBezierTo(width * 3 / 4, height / 2, width, height * 0.77)
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();

    Gradient gradient = LinearGradient(
      colors: [color1, const Color(0xFF462F57)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    Gradient gradient2 = LinearGradient(
      colors: [color1, Colors.pink],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    canvas.drawPath(
      path2,
      Paint()
        ..shader = gradient2.createShader(Rect.fromLTWH(0, 0, width, height))
        ..style = PaintingStyle.fill,
    );

    canvas.drawShadow(pathShadow, Colors.black, 10, true);
    canvas.drawPath(
      path,
      Paint()
        ..shader = gradient.createShader(Rect.fromLTWH(0, 0, width, height))
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
