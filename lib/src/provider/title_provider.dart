import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GreetingModel extends ChangeNotifier {
  String _greeting = 'Hello';

  String get greeting => _greeting;

  set greeting(String value) {
    _greeting = value;
    notifyListeners();
  }
}

final titleProvider = ChangeNotifierProvider((ref) => GreetingModel());
