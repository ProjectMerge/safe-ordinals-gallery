import 'package:flutter/material.dart';

import 'flat_custom_btn.dart';

class MenuItem extends StatelessWidget {
  final String picture;
  final int pageCurrent;
  final int page;
  final VoidCallback? onTap;

  const MenuItem({
    super.key,
    required this.page,
    required this.picture,
    required this.pageCurrent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
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