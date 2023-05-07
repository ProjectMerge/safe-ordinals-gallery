import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ordinals_pres/src/models/RefreshToken.dart';
import 'package:ordinals_pres/src/net_interface/app_exception.dart';
import 'package:ordinals_pres/src/support/secure_storage.dart';

import '/globals.dart' as globals;

class ComInterface {
  static const int serverAPI = 0;
  static const int serverAUTH = 1;
  static const int typePlain = 2;
  static const int typeJson = 3;
  static const int serverGoAPI = 4;

  static var _refreshingToken = false;

  Future<dynamic> get(String url,
      {Map<String, dynamic>? request, bool wholeURL = false, int serverType = serverAPI, Map<String, dynamic>? query, int? timeout, dynamic body, int type = typeJson, bool debug = false}) async {
    String? daoJWT = await SecureStorage.read(key: globals.TOKEN_DAO);
    String bearer = "";
    String payload = "";
    dynamic responseJson;
    http.Response response;

    var mUrl = "";
    if (!wholeURL) {
      mUrl = globals.API_URL + url;
    } else {
      mUrl = url;
    }

    if (serverType == ComInterface.serverAUTH) {
      mUrl = globals.AUTH_URL + url;
    }
    bearer = "JWT ${daoJWT ?? ""}";

    try {
      Map<String, String> mHeaders = {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "*",
        "Access-Control-Allow-Methods": "POST,GET,DELETE,PUT,OPTIONS",
        "Authorization": bearer,
        "Content-Type": "application/json",
        "payload": payload,
        "Auth-Type": "rsa"
      };

      response = await http.get(Uri.parse(mUrl), headers: mHeaders).timeout(Duration(seconds: timeout ?? 20), onTimeout: () {
        throw ConflictDataException('{"errorMessage":"Timeout"}');
      });
      if (debug) {
        debugPrint(mUrl);
        debugPrint(response.statusCode.toString());
      }
      if (response.statusCode == 401) {
        var timeLapsed = 0;
        try {
          while (_refreshingToken == true && timeLapsed < 300) {
            debugPrint("Waiting for token refresh");
            timeLapsed++;
            await Future.delayed(const Duration(milliseconds: 50));
          }
          timeLapsed = 0;
          await refreshToken();
          String? dJWT = await SecureStorage.read(key: globals.TOKEN_DAO);
          var b = "Bearer ${dJWT ?? ""}";
          Map<String, String> rHeaders = {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "*",
            "Access-Control-Allow-Methods": "POST,GET,DELETE,PUT,OPTIONS",
            "Authorization": b,
            "Content-Type": "application/json",
            "payload": payload,
            "Auth-Type": "rsa"
          };
          var resRefresh = await http.get(Uri.parse(mUrl), headers: rHeaders).timeout(const Duration(seconds: 20));
          if (type == typePlain) {
            return resRefresh;
          } else {
            var responseJson = compute(_returnResponse, resRefresh);
            return responseJson;
          }
        } catch (e) {
          responseJson = compute(_returnResponse, response);
        }
      }
      if (type == typePlain) {
        return response;
      }
      responseJson = compute(_returnResponse, response);
    } catch (e) {
      debugPrint(e.toString());
    }
    return responseJson;
  }

  Future<dynamic> post(String url, {Map<String, dynamic>? request, int serverType = serverAPI, dynamic body, int? timeout, int type = typeJson, bool debug = false, bool bandwidth = false}) async {
    String? daoJWT = await SecureStorage.read(key: globals.TOKEN_DAO);
    String bearer = "";
    String payload = "";
    dynamic responseJson;
    http.Response response;
    var mUrl = globals.API_URL + url;
    if (serverType == ComInterface.serverAUTH) {
      mUrl = globals.AUTH_URL + url;
    }
    bearer = "JWT ${daoJWT ?? ""}";
    Map<String, String> mHeaders = {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Headers": "*",
      "Access-Control-Allow-Methods": "POST,GET,DELETE,PUT,OPTIONS",
      "Authorization": bearer,
      "Content-Type": "application/json",
      "payload": payload,
      "Auth-Type": "rsa"
    };
    if (debug) {}

    var b = body != null ? json.encode(body) : null;
    response = await http.post(Uri.parse(mUrl), headers: mHeaders, body: b).timeout(Duration(seconds: timeout ?? 20), onTimeout: () {
      throw ConflictDataException('{"errorMessage":"Timeout"}');
    });
    if (debug) {
      debugPrint(mUrl);
      debugPrint(response.statusCode.toString());
      debugPrint(response.body);
    }

    if (response.statusCode == 401) {
      var timeLapsed = 0;

      while (_refreshingToken == true && timeLapsed < 300) {
        debugPrint("Waiting for token refresh");
        timeLapsed++;
        await Future.delayed(const Duration(milliseconds: 100));
      }
      timeLapsed = 0;
      await refreshToken();
      String? dJWT = await SecureStorage.read(key: globals.TOKEN_DAO);
      var bod = body != null ? json.encode(body) : null;
      var b = "JWT ${dJWT ?? ""}";
      Map<String, String> rHeaders = {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "*",
        "Access-Control-Allow-Methods": "POST,GET,DELETE,PUT,OPTIONS",
        "Authorization": b,
        "Content-Type": "application/json",
        "payload": payload,
        "Auth-Type": "rsa"
      };
      var resRefresh = await http.post(Uri.parse(mUrl), headers: rHeaders, body: bod).timeout(const Duration(seconds: 20));
      if (type == typePlain) {
        return resRefresh;
      } else {
        var responseJson = compute(_returnResponse, resRefresh);
        return responseJson;
      }
    }

    if (type == typePlain) {
      return response;
    }
    responseJson = compute(_returnResponse, response);
    return responseJson;
  }

  Future<void> refreshToken() async {
    debugPrint("/// RefreshToken ///");
    try {
      if (_refreshingToken) {
        return;
      }
      _refreshingToken = true;

      String? enc = await SecureStorage.read(key: globals.TOKEN_REFRESH);
      Map request = {
        "token": enc,
      };
      final resp = await http.post(Uri.parse("https://mobileapp.rocketbot.pro/api/auth/refreshToken"),
          body: json.encode(request), headers: {"accept": "application/json", "content-type": "application/json", "Auth-Type": "rsa"}).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          return http.Response('ErrorTimeOut', 500); // Request Timeout response status code
        },
      );

      TokenRefresh? res = TokenRefresh.fromJson(json.decode(resp.body));
      if (res.data!.token != null) {
        await SecureStorage.write(key: globals.TOKEN_DAO, value: res.data!.token!);
        await SecureStorage.write(key: globals.TOKEN_REFRESH, value: res.data!.refreshToken!);
        _refreshingToken = false;
      }
      _refreshingToken = false;
    } catch (e) {
      await SecureStorage.deleteStorage(key: globals.TOKEN_DAO);
      await SecureStorage.deleteStorage(key: globals.TOKEN_REFRESH);
      _refreshingToken = false;
      debugPrint(e.toString());
    }
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw ConflictDataException(response.body.toString());
      case 401:
        Map<String, dynamic> error = {
          "info": 'Error occured while Communication with Server with StatusCode:${response.statusCode}',
          "statusCode": response.statusCode,
          "messageBody": response.body.toString(),
        };
        throw UnauthorisedException(error);
      case 409:
        throw ConflictDataException(response.body.toString());
      case 403:
      case 422:
        Map<String, dynamic> error = {
          "info": 'Error occured while Communication with Server with StatusCode:${response.statusCode}',
          "statusCode": response.statusCode,
          "messageBody": response.body.toString(),
        };
        throw UnauthorisedException(error);
      case 404:
        Map<String, dynamic> error = {
          "info": 'Error occured while Communication with Server with StatusCode:${response.statusCode}',
          "statusCode": response.statusCode,
          "messageBody": response.body.toString(),
        };
        throw UnauthorisedException(error);
      case 500:
      default:
        throw ConflictDataException(response.body.toString());
    }
  }
}
