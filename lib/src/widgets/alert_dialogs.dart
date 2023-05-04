import 'package:qr_flutter/qr_flutter.dart';
import 'package:universal_io/io.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rckt_launch_app/src/support/extensions.dart';

Future<bool?> showAlertDialog({
  required BuildContext context,
  required String title,
  String? content,
  String? cancelActionText,
  String defaultActionText = 'OK',
}) async {
  if (kIsWeb || !Platform.isIOS) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 20),),
        content: content != null ? Text(content, style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 24)) : null,
        actions: <Widget>[
          if (cancelActionText != null)
            TextButton(
              child: Text(cancelActionText, style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 18)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          TextButton(
            child: Text(defaultActionText, style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 18)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }
  return showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title, style: Theme.of(context).textTheme.displayLarge,),
      content: content != null ? Text(content) : null,
      actions: <Widget>[
        if (cancelActionText != null)
          CupertinoDialogAction(
            child: Text(cancelActionText),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        CupertinoDialogAction(
          child: Text(defaultActionText),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}

Future<void> showWaitDialog({
  required BuildContext context,
  required String title,
  String? content,
  String? cancelActionText,
  String defaultActionText = 'OK',
}) async {
  if (kIsWeb || !Platform.isIOS) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text(title, style: Theme
                .of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontSize: 20),),
            content: const SizedBox(
              width: 100,
              height: 100,
              child: Center(
                child: CircularProgressIndicator(color: Colors.black87,strokeWidth: 2.0,),
              ),
            ),
            actions: const <Widget>[
            ],
          ),
    );
}}

Future<bool?> showQRAlertDialog({
  required BuildContext context,
  required String title,
  String? content,
  String? cancelActionText,
  String defaultActionText = 'OK',
}) async {
  if (kIsWeb || !Platform.isIOS) {
    return showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text(title, style: Theme
                .of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontSize: 20),),
            content: SizedBox(
              width: 200,
              height: 200,
              child: Center(
                child: QrImage(
                  dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square),
                  eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square),
                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                  data: content.toString(),
                  foregroundColor: Colors.black87,
                  version: QrVersions.auto,
                  size: 200,
                  gapless: false,
                ),
              ),
            ),
            actions: const <Widget>[
            ],
          ),
    );
  }
  return showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title, style: Theme.of(context).textTheme.displayLarge,),
      content: content != null ? Text(content) : null,
      actions: <Widget>[
        if (cancelActionText != null)
          CupertinoDialogAction(
            child: Text(cancelActionText),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        CupertinoDialogAction(
          child: Text(defaultActionText),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}

/// Generic function to show a platform-aware Material or Cupertino error dialog
Future<void> showExceptionAlertDialog({
  required BuildContext context,
  required String title,
  required dynamic exception,
}) =>
    showAlertDialog(
      context: context,
      title: title,
      content: exception.toString(),
      defaultActionText: 'OK'.hardcoded,
    );

Future<void> showNotImplementedAlertDialog({required BuildContext context}) =>
    showAlertDialog(
      context: context,
      title: 'Not implemented'.hardcoded,
    );