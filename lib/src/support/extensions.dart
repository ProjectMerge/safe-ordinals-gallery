import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ordinals_pres/src/widgets/alert_dialogs.dart';

/// A simple placeholder that can be used to search all the hardcoded strings
/// in the code (useful to identify strings that need to be localized).
extension StringHardcoded on String {
  String get hardcoded => this;
}

extension AsyncValueUI on AsyncValue {
  void showAlertDialogOnError(BuildContext context) {
    if (!isLoading && hasError) {
      showExceptionAlertDialog(
        context: context,
        title: 'Error'.hardcoded,
        exception: error,
      );
    }
  }
}

extension BoolParsing on String? {
  bool parseBool() {
    if (null == this) {
      throw '"$this" can not be parsed to boolean.';
    }else{
      if (this!.toLowerCase() == 'true') {
        return true;
      } else if (this!.toLowerCase() == 'false') {
        return false;
      }
    }

    throw '"$this" can not be parsed to boolean.';
  }
}