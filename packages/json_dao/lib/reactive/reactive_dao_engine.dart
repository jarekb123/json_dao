import 'package:json_dao/json_dao_engine.dart';

mixin ReactiveDaoEngine on JsonDaoEngine {
  Stream<Map<String, Map<String, dynamic>>> observeAll();

  Stream<Map<String, dynamic>> observeObject(String id);
}
