import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime/mime.dart';
import 'package:ordinals_pres/src/models/nsfw_resp.dart';
import 'package:ordinals_pres/src/net_interface/interface.dart';
import 'package:ordinals_pres/src/support/s_p.dart';
import 'package:http/http.dart' as http;


class PicProvider extends StateNotifier<AsyncValue<Map<String,dynamic>>> {
  Uint8List? _pictureData;
  final ref;
  PicProvider(this.ref): super(const AsyncData({}));

  Uint8List? get getMNConf => _pictureData;

  void getPicture(String? id) async {
    if (state is AsyncLoading) return;
    if (id == null || id.isEmpty) {
      state = const AsyncData(<String, dynamic>{"status": "empty"});
      return;
    }
    try {
      state = const AsyncLoading();
      final response = await http.get(Uri.parse('https://ordinals.com/content/$id'));
      if (response.statusCode == 200) {
        final responseData = response.bodyBytes;
        var b = await parseImage(responseData, response.headers["content-type"] ?? "text/html");
        if (b.status != "ok") {
          state = state = AsyncData(<String, dynamic>{
            "image" : responseData,
            "nsfw" : false,
            "status" :"unsupported mimeType"
          });
          return;
        }else if (b.nsfwPic! || b.nsfwText!) {
          state = AsyncData(<String, dynamic>{
            "image" : responseData,
            "nsfw" : true,
          });
        }else {
          state = AsyncData(<String, dynamic>{
            "image" : responseData,
            "nsfw" : false,
            "status" :"unsupported mimeType"
          });
        }
      } else {
        state = const AsyncData(<String, dynamic>{
          "image" : null,
          "nsfw" : false,
          "status" : "Invalid URL",
        });
      }
    } catch (e, st) {
      print(e.toString());
      state = AsyncError(e, st);
    }
  }

  Future<NSFWResponse> parseImage(Uint8List s, String mimeType) async {
    // final base64 = base64Encode(s);
    final mime = lookupMimeType('', headerBytes: s);
    final extension = mimeType.split("/")[0].split(";")[0];
    bool bp = extension == "jpg" || extension == "jpeg" || extension == "png" || extension == "webp";
    if (bp) {
     var cls = await processImage(s, extension);
     return cls;
    }else{
      return NSFWResponse(status: "Unsupported mimeType");
    }
  }

  Future<NSFWResponse> processImage(Uint8List s, String type) async {
    final base64 = base64Encode(s);
    final filename = "image.$type";
    final net = ref.read(networkProvider);

    Map<String, dynamic> m = {
      "base64" : base64,
      "filename" :filename,
    };

    try {
      http.Response r = await ComInterface().post("/pic/check", body: m, debug: true, serverType: ComInterface.serverAUTH, type: ComInterface.typePlain, request: {});
      if (r.statusCode == 200) {
            print("OK");
            return NSFWResponse.fromJson(jsonDecode(r.body));
          } else {
            print("shit");
            return NSFWResponse(status: "Fail");
          }
    } catch (e) {
      print(e);
      return NSFWResponse(status: "Fail");
    }


  }
}

final pictureProvider = StateNotifierProvider<PicProvider, AsyncValue<Map<String,dynamic>>>((ref) {
  return PicProvider(ref);
});