import 'package:flutter/material.dart';
import 'package:ordinals_pres/src/support/app_sizes.dart';

import 'flat_custom_btn.dart';

class MenuItem extends StatelessWidget {
  final String picture;
  final int pageCurrent;
  final int page;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const MenuItem({
    super.key,
    required this.page,
    required this.picture,
    required this.pageCurrent,
    this.onTap, this.width = double.infinity, this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FlatCustomButton(
        onTap: onTap,
        color: Colors.transparent,
        splashColor: Colors.black12,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: 25,
                    height: 28,
                    child: Image.asset(picture, isAntiAlias: true, color: page == pageCurrent ? Colors.black87 : Colors.black87)),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 5,
                height: 25,
                decoration: BoxDecoration(
                    color: page == pageCurrent ? Colors.black87 : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItemMobile extends StatelessWidget {
  final String picture;
  final int pageCurrent;
  final int page;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const MenuItemMobile({
    super.key,
    required this.page,
    required this.picture,
    required this.pageCurrent,
    this.onTap, this.width = double.infinity, this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FlatCustomButton(
        onTap: onTap,
        color: Colors.transparent,
        splashColor: Colors.black12,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.asset(picture, isAntiAlias: true, color: page == pageCurrent ? const Color(0xFF1A233D) : Colors.black87)),
              ),
            ),
            gapH8,
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastLinearToSlowEaseIn,
                width: 30,
                height: 3,
                decoration: BoxDecoration(
                    color: page == pageCurrent ? const Color(0xFF1A233D).withOpacity(0.8) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10))
              ),
            ),
          ],
        ),
      ),
    );
  }
}