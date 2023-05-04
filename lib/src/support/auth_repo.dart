import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:ordinals_pres/globals.dart' as globals;
import 'package:ordinals_pres/src/exceptions/app_exception.dart';
import 'package:ordinals_pres/src/models/AppUser.dart';
import 'package:ordinals_pres/src/net_interface/interface.dart';
import 'package:ordinals_pres/src/support/memory_store.dart';
import 'package:ordinals_pres/src/support/secure_storage.dart';

class AuthRepository {
  final _authState = InMemoryStore<AppUser?>(null);

  Stream<AppUser?> authStateChanges() => _authState.stream;

  AppUser? get currentUser => _authState.value;

  set currentUser(AppUser? user) {
    _authState.value = user;
  }

  Future<void> signInWithEmailAndPassword(String email, String password, {String? pin}) async {
    Map<String, dynamic> m = {
      "username": email,
      "password": password,
    };
    if (pin != null) {
      m['twoFactor'] = pin;
    }

    ComInterface ci = ComInterface();
    Response res = await ci.post("/login", body: m, serverType: ComInterface.serverGoAPI, type: ComInterface.typePlain, debug: false);

    if (res.statusCode == 200) {
      Map<String, dynamic> r = json.decode(res.body.toString());
      var username = r["username"];
      var addr = r["addr"];
      var jwt = r["jwt"];
      var userID = r["userid"];
      var adminPriv = r["admin"];
      var nickname = r["nickname"];
      var tokenDao = r["token"];
      var refreshToken = r['refresh_token'];

      await SecureStorage.write(key: globals.NAME, value: username);
      await SecureStorage.write(key: globals.ADR, value: addr);
      await SecureStorage.write(key: globals.ID, value: userID.toString());
      await SecureStorage.write(key: globals.TOKEN, value: jwt);
      await SecureStorage.write(key: globals.ADMINPRIV, value: adminPriv.toString());
      await SecureStorage.write(key: globals.NICKNAME, value: nickname.toString());
      await SecureStorage.write(key: globals.TOKEN_DAO, value: tokenDao.toString());
      await SecureStorage.write(key: globals.TOKEN_REFRESH, value: refreshToken.toString());
      _authState.value = AppUser(
        name: userID.toString(),
        email: email,
        admin: adminPriv == null
            ? false
            : adminPriv == "1"
                ? true
                : false,
      );
    } else if (res.statusCode == 409) {
      throw const AppException.emailAlreadyInUse();
    } else if (res.statusCode == 404) {
      throw const AppException.wrongPassword();
    }
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    if (currentUser == null) {
      _createNewUser(email);
    }
  }

  void checkIfLoggedIn() async {
    var s = await daoLogin();
    if (s == true) {
      ;
      var id = await SecureStorage.read(key: globals.NAME);
      var email = await SecureStorage.read(key: globals.EMAIL);
      var admin = await SecureStorage.read(key: globals.ADMINPRIV);
      _authState.value = AppUser(
        name: id.toString(),
        email: email,
        admin: admin == null
            ? false
            : admin == "1"
                ? true
                : false,
      );
    } else {}
  }

  Future<bool> daoLogin() async {
    ComInterface ci = ComInterface();
    Response r = await ci.get("/ping", debug: true, serverType: ComInterface.serverAUTH, type: ComInterface.typePlain, request: {});
    if (r.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> signOut() async {
    await SecureStorage.deleteStorage(key: globals.NAME);
    await SecureStorage.deleteStorage(key: globals.ADR);
    await SecureStorage.deleteStorage(key: globals.ID);
    await SecureStorage.deleteStorage(key: globals.TOKEN);
    await SecureStorage.deleteStorage(key: globals.ADMINPRIV);
    await SecureStorage.deleteStorage(key: globals.NICKNAME);
    await SecureStorage.deleteStorage(key: globals.TOKEN_DAO);
    await SecureStorage.deleteStorage(key: globals.TOKEN_REFRESH);
    await SecureStorage.deleteStorage(key: globals.ADMINPRIV);
    _authState.value = null;
  }

  void dispose() => _authState.close();

  void _createNewUser(String email) {
    _authState.value = AppUser(
      name: email.split('').reversed.join(),
      email: email,
      admin: false,
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final auth = AuthRepository();
  ref.onDispose(() => auth.dispose());
  return auth;
});

final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
