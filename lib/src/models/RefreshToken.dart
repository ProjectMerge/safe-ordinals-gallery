/// message : "string"
/// hasError : true
/// error : "string"
/// data : {"refreshToken":"string","token":"string"}

class TokenRefresh {
  TokenRefresh({
    String? message,
    bool? hasError,
    String? error,
    Data? data,}){
    _message = message;
    _hasError = hasError;
    _error = error;
    _data = data;
  }

  TokenRefresh.fromJson(dynamic json) {
    _message = json['message'];
    _hasError = json['hasError'];
    _error = json['error'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? _message;
  bool? _hasError;
  String? _error;
  Data? _data;

  String? get message => _message;
  bool? get hasError => _hasError;
  String? get error => _error;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['hasError'] = _hasError;
    map['error'] = _error;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// refreshToken : "string"
/// token : "string"

class Data {
  Data({
    String? refreshToken,
    String? token,}){
    _refreshToken = refreshToken;
    _token = token;
  }

  Data.fromJson(dynamic json) {
    _refreshToken = json['refreshToken'];
    _token = json['token'];
  }
  String? _refreshToken;
  String? _token;

  String? get refreshToken => _refreshToken;
  String? get token => _token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['refreshToken'] = _refreshToken;
    map['token'] = _token;
    return map;
  }

}