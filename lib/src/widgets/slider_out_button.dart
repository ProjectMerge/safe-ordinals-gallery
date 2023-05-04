import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rckt_launch_app/src/support/app_sizes.dart';
import 'package:rckt_launch_app/src/widgets/flat_custom_btn.dart';

class SlideOutButton extends StatefulWidget {
  final double? width;
  final String? openText;
  final String? closeText;
  final double radius;
  final bool revertBack;
  final Function(bool force)  onTap;
  final Duration reverTime;
  final Color? color;

  const SlideOutButton({Key? key, this.width, this.openText, this.closeText, this.radius = 10.0, this.revertBack = false, required this.onTap, this.reverTime = const Duration(seconds: 3), this.color}) : super(key: key);

  @override
  SlideOutButtonState createState() => SlideOutButtonState();
}

class SlideOutButtonState extends State<SlideOutButton> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  Timer? t;

  bool _isChecked = false;
  bool _isButtonSlid = false;
  bool _isConfirmed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    // curve: Curves.bounceOut
    _animation = Tween<double>(
      begin: 0,
      end: -0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.fastLinearToSlowEaseIn));
  }

  void startTimer() {
    if (!widget.revertBack) return;
    t = Timer(widget.reverTime, () {
      if (_isButtonSlid) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
      setState(() {
        _isButtonSlid = !_isButtonSlid;
      });
      t?.cancel();
    });
  }

  @override
  void dispose() {
    t?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maskWidth = widget.width ?? 200.0;
    return ClipPath(
      clipper: MyClipper(
        height: 50,
        width: maskWidth,
        borderRadius: widget.radius,
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
              width: maskWidth,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(widget.radius),
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  AnimatedSize(
                    duration: widget.reverTime,
                    reverseDuration: const Duration(milliseconds: 50),
                    curve: Curves.linear,
                    child: Container(
                      width: _isButtonSlid ? maskWidth : 0,
                      height: 50,
                      color: Colors.blue.shade100,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text("Force", style: TextStyle(fontSize: 20, color: Colors.white)),
                      gapW4,
                      Checkbox(
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value ?? false;
                          });
                        },
                      ),
                      gapW24,
                    ],
                  ),
                ],
              )),
          AnimatedBuilder(
            animation: _animation,
            builder: (BuildContext context, Widget? child) {
              // ignore: avoid_returning_null
              return Transform(
                transform: Matrix4.translationValues(_animation.value * maskWidth, 0, 0),
                child: child,
              );
            },
            child: FlatCustomButton(
              width: maskWidth,
              height: 50,
              color: _isConfirmed ? Colors.lightGreen : _isButtonSlid ?  Colors.green : widget.color ?? Colors.blue,
              splashColor: _isConfirmed ? Colors.lightGreen.shade400 : _isButtonSlid ? Colors.green.shade400 : widget.color?.withOpacity(0.7) ?? Colors.blue.shade400,
              radius: widget.radius,
              onTap: () {
                if (_isConfirmed) return;
                if (_isButtonSlid) {
                  setState(() {
                    _isConfirmed = true;
                  });
                  t?.cancel();
                  widget.onTap.call(_isChecked);
                  _controller.reverse();
                } else {
                  startTimer();
                  _controller.forward();
                }
                setState(() {
                  _isButtonSlid = !_isButtonSlid;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 8),
                  //animation strecht divider
                  AnimatedContainer(duration: const Duration(milliseconds: 500), curve: Curves.fastLinearToSlowEaseIn, width: _isButtonSlid ? maskWidth / 2 : 0, height: 30, color: Colors.transparent),
                  if(!_isConfirmed)
                  Text(
                    _isButtonSlid ? widget.openText ?? 'Save' : widget.closeText ?? 'Edit',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  if(_isConfirmed)
                  const Icon(Icons.check, color: Colors.white, size: 30,)

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  final double height;
  final double width;
  final double borderRadius;

  MyClipper({required this.height, required this.width, required this.borderRadius});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, width, height),
      Radius.circular(borderRadius),
    ));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
