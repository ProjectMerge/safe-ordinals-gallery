import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginNotifierProvider extends ChangeNotifier {
  bool _greeting = false;

  bool get greeting => _greeting;

  set greeting(bool value) {
    _greeting = value;
    notifyListeners();
  }
}

final loginProvider = ChangeNotifierProvider((ref) => LoginNotifierProvider());