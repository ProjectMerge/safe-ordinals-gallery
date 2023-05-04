import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ordinals_pres/src/net_interface/interface.dart';

class StorageProvider {
  final storageProvider = const FlutterSecureStorage(webOptions: WebOptions(dbName: "CNliCGCAgu", publicKey: "adfafadfasdf873yh3fn8bf"));
  final cm = ComInterface();
}

final storageProvider = Provider<FlutterSecureStorage>((ref) {
  final auth = StorageProvider();
  return auth.storageProvider;
});

final networkProvider = Provider<ComInterface>((ref) {
  final auth = StorageProvider();
  return auth.cm;
});
