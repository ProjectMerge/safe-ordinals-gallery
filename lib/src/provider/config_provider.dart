import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ordinals_pres/src/net_interface/interface.dart';
import 'package:ordinals_pres/src/support/s_p.dart';

final configProvider = FutureProvider.family<String?, int>((ref, id) async {
  try {
    Map<String, dynamic> m = {
      "idNode": id,
    };
    dynamic response = await ref.read(networkProvider).post("/masternode/non/config", body: m, serverType: ComInterface.serverGoAPI, debug: false );
    if (response["config"] != null) {
      return response["config"];
    }else{
      return null;
    }
  } catch (e) {
    return null;
  }
});