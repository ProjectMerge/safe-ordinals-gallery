import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime/mime.dart';
import 'package:ordinals_pres/src/models/nsfw_resp.dart';
import 'package:ordinals_pres/src/net_interface/interface.dart';
import 'package:ordinals_pres/src/support/s_p.dart';
import 'package:http/http.dart' as http;

class PicProvider extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  Uint8List? _pictureData;
  final ref;

  PicProvider(this.ref) : super(const AsyncData({}));

  Uint8List? get getMNConf => _pictureData;

  void getPicture(String? id) async {
    if (state is AsyncLoading) return;
    if (id == null || id.isEmpty) {
      state = const AsyncData(<String, dynamic>{"status": "empty"});
      return;
    }
    try {
      state = const AsyncLoading();
      final response = await processImage(id);
      if (response.status!.toLowerCase() == "ok") {
        if (response.nsfwText == false && response.nsfwPic == false) {
          Uint8List bytesImage = const Base64Decoder().convert(response.base64!);
          state = AsyncData(<String, dynamic>{"image": bytesImage, "filename": response.filename, "nsfw": false, "status": response.status});
        } else {
          state = AsyncData(<String, dynamic>{"image": "", "filename": "", "message": "is nsfw", "nsfw": true, "status": response.status});
        }
      } else {
        state = state = AsyncData(<String, dynamic>{"message": response.message, "nsfw": false, "status": response.status});
        return;
      }
    } catch (e, st) {
      print(e.toString());
      state = AsyncError(e, st);
    }
  }

  Future<NSFWResponse> processImage(String tx) async {
    try {
      http.Response r =
          await ComInterface().get("/ord/$tx", debug: true, serverType: ComInterface.serverAUTH, type: ComInterface.typePlain, request: {});
      if (r.statusCode == 200) {
        print("OK");
        return NSFWResponse.fromJson(jsonDecode(r.body));
      } else {
        print("shit");
        var err = NSFWResponse.fromJson(jsonDecode(r.body));
        return NSFWResponse(status: err.status, message: err.message ?? r.statusCode.toString());
      }
    } catch (e) {
      print(e);
      return NSFWResponse(status: "Fail");
    }
  }
}

final pictureProvider = StateNotifierProvider<PicProvider, AsyncValue<Map<String, dynamic>>>((ref) {
  return PicProvider(ref);
});
