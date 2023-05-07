import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ordinals_pres/src/support/app_sizes.dart';

class GalleryHeroWidget extends StatelessWidget {
  final String tag;
  final String data;
  const GalleryHeroWidget({Key? key, required this.tag, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(tag: tag, child:
    Container(
          width: MediaQuery.of(context).size.width * 0.8 > 600
              ? MediaQuery.of(context).size.width * 0.8
              : 600,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Image.memory(
                      base64.decode(data),
                      fit: BoxFit.fill,
                    )),
                gapH8,
                AutoSizeText(
                  tag,
                  style: const TextStyle(color: Colors.black54),
                  maxLines: 1,
                  minFontSize: 8,
                ),
              ],
            ),
          ),
        ),
      );
  }
}
