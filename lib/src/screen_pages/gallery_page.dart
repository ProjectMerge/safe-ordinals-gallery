import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ordinals_pres/src/storage/data_model.dart';
import 'package:ordinals_pres/src/support/app_sizes.dart';
import 'package:ordinals_pres/src/support/breakpoints.dart';

class GalleryPage extends ConsumerStatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  ConsumerState<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends ConsumerState<GalleryPage> {
  List<MyData> _data = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var box = await Hive.openBox<MyData>('gallery');
    _data = box.values.toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, cons) {
        final size = cons.biggest;
        final isDesktop = size.width > Breakpoint.tablet;
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: isDesktop ? _buildDesktop(size) : _buildMobile(size),
        );
      },
    );
  }

  Widget _buildDesktop(Size size) {
    return Column(
      children: [
        gapH32,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            "Safe Ordinals Gallery",
            style: TextStyle(fontSize: 24, color: Colors.black54),
          ),
        ),
        gapH32,
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
            ),
            itemCount: _data.length,
            itemBuilder: (BuildContext context, int index) {
              var data = _data[index];
              return Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white30),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Image.memory(
                        base64.decode(data.base64),
                        fit: BoxFit.fill,
                      )),
                      gapH8,
                      AutoSizeText(
                        data.name,
                        style: const TextStyle(color: Colors.black54),
                        maxLines: 1,
                        minFontSize: 8,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildMobile(Size size) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFEBEAF8),
              Color(0xFFF5EEF1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            gapH32,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Safe Ordinals Gallery",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
            gapH32,
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: _data.length,
                itemBuilder: (BuildContext context, int index) {
                  var data = _data[index];
                  return Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Image.memory(
                                base64.decode(data.base64),
                                fit: BoxFit.fill,
                              )),
                          gapH8,
                          AutoSizeText(
                            data.name,
                            style: const TextStyle(color: Colors.black54),
                            maxLines: 1,
                            minFontSize: 8,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

}
