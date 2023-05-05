import 'package:hive/hive.dart';

part 'data_model.g.dart';

@HiveType(typeId: 0)
class MyData extends HiveObject {
  @HiveField(0)
  String base64;
  @HiveField(1)
  String name;

  MyData({required this.name, required this.base64});
}