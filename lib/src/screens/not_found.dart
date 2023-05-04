import 'package:flutter/material.dart';
import 'package:rckt_launch_app/src/support/empty_placeholder.dart';
import 'package:rckt_launch_app/src/support/extensions.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.red,
        child: EmptyPlaceholderWidget(
          message: '404 - Page not found!'.hardcoded,
        ),
      ),
    );
  }
}