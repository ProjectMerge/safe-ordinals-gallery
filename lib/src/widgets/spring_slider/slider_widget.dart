import './slider_painter.dart';
import './thumb_painter.dart';
import 'package:flutter/material.dart';

typedef Change<T, U> = void Function(T progress, U preciseProgress);

class SliderWidget extends StatefulWidget {
  final double width;
  final double height;
  final Change<int, double> onChanged;
  final Duration? springDuration;

  const SliderWidget({Key? key, required this.width, required this.height, required this.onChanged, this.springDuration = const Duration(milliseconds: 500)}) : super(key: key);

  @override
  SliderWidgetState createState() => SliderWidgetState();
}

class SliderWidgetState extends State<SliderWidget> with SingleTickerProviderStateMixin {
  late double widgetWidth = widget.width;
  late double widgetHeight = widget.height;

  //created due for smoother start end of the slider
  final double paddingWidth = 2;

  Offset _dragPosition = const Offset(0, 0);

  // Animation
  late AnimationController _animationController;
  late Animation _sliderAnimation;

  double _animBeginValue = 0;
  double _animEndValue = 0;

  bool _isDragging = false;

  double _progress = 0;

  @override
  void initState() {
    super.initState();

    // Init default anim values
    _animBeginValue = widgetHeight / 2;
    _animEndValue = widgetHeight / 2;

    _animationController = AnimationController(
      vsync: this,
      duration: widget.springDuration,
    );

    // init animation
    _initAnimation();

    // play anim
    _animationController.forward();
  }

  void _initAnimation() {
    _sliderAnimation = Tween<double>(
      begin: _animBeginValue,
      end: _animEndValue,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.bounceOut),
    )..addListener(() {
        setState(() {});
      });
  }

  // Cap drag values between widget height and width
  void _capDragPosition() {
    // Y-Axis
    if (_dragPosition.dy >= widgetHeight) {
      _dragPosition = Offset(_dragPosition.dx, widgetHeight);
    } else if (_dragPosition.dy <= 0) {
      _dragPosition = Offset(_dragPosition.dx, 0);
    }

    // X-Axis
    if (_dragPosition.dx >= widgetWidth - paddingWidth) {
      _dragPosition = Offset(widgetWidth - paddingWidth, _dragPosition.dy);
    } else if (_dragPosition.dx <= paddingWidth) {
      _dragPosition = Offset(paddingWidth, _dragPosition.dy);
    }
  }

  double _paddingCorrection(double value) {
    final shiftedValue = value - (paddingWidth / 2);
    final convertedValue = (shiftedValue / (100 - paddingWidth)) * 100;
    return convertedValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (value) {
        setState(() {
          _isDragging = true;

          // Dragging,
          _dragPosition = Offset(value.localPosition.dx, value.localPosition.dy);

          _capDragPosition();

          // set progress
          _progress = (_dragPosition.dx / widgetWidth) * 100;
          widget.onChanged(_paddingCorrection(_progress).toInt(), _paddingCorrection(_progress));
        });
      },
      onPanEnd: (value) {
        setState(() {
          _isDragging = false;

          _animBeginValue = _dragPosition.dy;
          _animEndValue = widgetHeight / 2;

          _animationController.reset();

          _initAnimation();

          _animationController.forward();
        });
      },
      child: SizedBox(
        width: widgetWidth,
        height: widgetHeight,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: widgetWidth,
                height: widgetHeight,
                child: CustomPaint(
                  painter: SliderPainter(
                    dragPosition: _isDragging ? _dragPosition : Offset(_dragPosition.dx, _sliderAnimation.value),
                    sliderColor: Colors.black.withAlpha(30),
                  ),
                ),
              ),
            ),
            ClipRRect(
              child: Align(
                alignment: Alignment.centerLeft,
                widthFactor: _progress / 100,
                child: SizedBox(
                  width: widgetWidth,
                  height: widgetHeight,
                  child: CustomPaint(
                    painter: SliderPainter(
                      dragPosition: _isDragging ? _dragPosition : Offset(_dragPosition.dx, _sliderAnimation.value),
                      sliderColor: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              widthFactor: _progress / 100,
              child: SizedBox(
                width: widgetWidth,
                height: widgetHeight,
                child: CustomPaint(
                  painter: ThumbPainter(
                    dragPosition: _isDragging ? _dragPosition : Offset(_dragPosition.dx, _sliderAnimation.value),
                    sliderColor: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
