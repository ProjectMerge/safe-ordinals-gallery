import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ordinals_pres/src/net_interface/interface.dart';
import 'package:ordinals_pres/src/support/s_p.dart';

final galleryProvider = FutureProvider<GalleryRes?>((ref) async {
  List<GalleryRes> galleryRes = [];
  try {
    dynamic response = await ComInterface().get("/gallery", serverType: ComInterface.serverGoAPI, debug: false );
    if (response["gallery"] != null) {
      return GalleryRes.fromJson(response);
    }else{
      return null;
    }
  } catch (e) {
    print(e.toString());
    return null;
  }
});

class GalleryRes {
  List<Gallery>? gallery;

  GalleryRes({this.gallery});

  GalleryRes.fromJson(Map<String, dynamic> json) {
    if (json['gallery'] != null) {
      gallery = <Gallery>[];
      json['gallery'].forEach((v) {
        gallery!.add(Gallery.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (gallery != null) {
      data['gallery'] = gallery!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Gallery {
  String? ordId;
  String? base64;

  Gallery({this.ordId, this.base64});

  Gallery.fromJson(Map<String, dynamic> json) {
    ordId = json['ord_id'];
    base64 = json['base64'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ord_id'] = ordId;
    data['base64'] = base64;
    return data;
  }
}
