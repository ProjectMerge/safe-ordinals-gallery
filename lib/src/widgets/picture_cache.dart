import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ordinals_pres/src/net_interface/interface.dart';

class PictureCacheWidget extends StatefulWidget {
  final String? smallUrl;
  final int? coindID;
  final bool? ok;
  final double? size;

  const PictureCacheWidget({Key? key, this.smallUrl, this.size, this.ok, this.coindID}) : super(key: key);
  static Map<String, dynamic> cache = {};
  @override
  State<PictureCacheWidget> createState() => _PictureCacheWidgetState();
}



class _PictureCacheWidgetState extends State<PictureCacheWidget> {


  String? fileName;
  bool check = false;
  Uint8List? image64;

  @override
  void initState() {
    super.initState();
    if (widget.smallUrl != null) {
      _handleFile();
    }
    if (widget.coindID != null) {
      _handleFileID();
    }
    if (widget.ok != null) {
      check = widget.ok!;
    }
  }

  bool getCheck() {
    if (widget.ok != null) {
      check = widget.ok!;
    } else {
      check = true;
    }
    return check;
  }

  @override
  void setState(fn) {
    if (context.mounted) {
      super.setState(fn);
    }
  }

  _handleFile() async {
    ComInterface net = ComInterface();
    if (PictureCacheWidget.cache.containsKey(widget.smallUrl.toString())) {
      if (mounted) {
        setState(() {
          image64 = PictureCacheWidget.cache[widget.smallUrl.toString()];
        });
      }
      return;
    }
    Response response = await net.post('/image/proxy',body: {"url" : widget.smallUrl}, type: ComInterface.typePlain);
    try {
      var f = base64.decode(json.decode(response.body)['image']);
      if (mounted) {
            PictureCacheWidget.cache[widget.smallUrl.toString()] = f;
            setState(() {
              image64 = f;
            });
          }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _handleFileID() async {
    ComInterface net = ComInterface();
    if (PictureCacheWidget.cache.containsKey(widget.coindID.toString())) {
      if (mounted) {
        setState(() {
          image64 = PictureCacheWidget.cache[widget.coindID.toString()];
        });
      }
      return;
    }
    Response response = await net.post('/image/id',body: {"coinID" : widget.coindID}, type: ComInterface.typePlain);
    try {
      var f = base64.decode(json.decode(response.body)['image']);
      if (mounted) {
        PictureCacheWidget.cache[widget.coindID.toString()] = f;
        setState(() {
          image64 = f;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
    switchInCurve: Curves.fastOutSlowIn,
    switchOutCurve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
          child: image64 != null
              ?  SizedBox(
                key: UniqueKey(),
              width: widget.size ?? double.infinity,
              height: widget.size ?? double.infinity,
              child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(ColorFilterGenerator.saturationAdjustMatrix(
                    value: getCheck() ? 0.0 : -1.0,
                  )),
                  child: image64 != null ? Image.memory(image64!,) : Container(height: 10,width: 10, color: Colors.red,),))
        : SizedBox(
      key: UniqueKey(),
      width: widget.size ?? double.infinity,
      height: widget.size ?? double.infinity,
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: CircularProgressIndicator(strokeWidth: 1.0, color: Colors.black54,),
        ),
      ),
    ));
  }
}

class ColorFilterGenerator {
  static List<double> hueAdjustMatrix({required double value}) {
    value = value * pi;

    if (value == 0) {
      return [
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ];
    }

    double cosVal = cos(value);
    double sinVal = sin(value);
    double lumR = 0.213;
    double lumG = 0.715;
    double lumB = 0.072;

    return List<double>.from(<double>[
      (lumR + (cosVal * (1 - lumR))) + (sinVal * (-lumR)),
      (lumG + (cosVal * (-lumG))) + (sinVal * (-lumG)),
      (lumB + (cosVal * (-lumB))) + (sinVal * (1 - lumB)),
      0,
      0,
      (lumR + (cosVal * (-lumR))) + (sinVal * 0.143),
      (lumG + (cosVal * (1 - lumG))) + (sinVal * 0.14),
      (lumB + (cosVal * (-lumB))) + (sinVal * (-0.283)),
      0,
      0,
      (lumR + (cosVal * (-lumR))) + (sinVal * (-(1 - lumR))),
      (lumG + (cosVal * (-lumG))) + (sinVal * lumG),
      (lumB + (cosVal * (1 - lumB))) + (sinVal * lumB),
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]).map((i) => i.toDouble()).toList();
  }

  static List<double> brightnessAdjustMatrix({required double value}) {
    if (value <= 0) {
      value = value * 255;
    } else {
      value = value * 100;
    }

    if (value == 0) {
      return [
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ];
    }

    return List<double>.from(<double>[1, 0, 0, 0, value, 0, 1, 0, 0, value, 0, 0, 1, 0, value, 0, 0, 0, 1, 0]).map((i) => i.toDouble()).toList();
  }

  static List<double> saturationAdjustMatrix({required double value}) {
    value = value * 100;

    if (value == 0) {
      return [
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ];
    }

    double x = ((1 + ((value > 0) ? ((3 * value) / 100) : (value / 100)))).toDouble();
    double lumR = 0.3086;
    double lumG = 0.6094;
    double lumB = 0.082;

    return List<double>.from(<double>[
      (lumR * (1 - x)) + x,
      lumG * (1 - x),
      lumB * (1 - x),
      0,
      0,
      lumR * (1 - x),
      (lumG * (1 - x)) + x,
      lumB * (1 - x),
      0,
      0,
      lumR * (1 - x),
      lumG * (1 - x),
      (lumB * (1 - x)) + x,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]).map((i) => i.toDouble()).toList();
  }
}
