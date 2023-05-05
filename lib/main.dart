import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ordinals_pres/src/storage/data_model.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Paint.enableDithering = true;

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(MyDataAdapter());
  await Hive.openBox<MyData>('gallery');

  usePathUrlStrategy();

  runApp(const ProviderScope(child: MyApp()));
}
