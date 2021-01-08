import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:json_dao/json_dao_engine.dart';
import 'package:json_dao/reactive_dao.dart';

class MemoryDaoEngine implements JsonDaoEngine, ReactiveDaoEngine {
  final _cache = BehaviorSubject<Map<String, Map<String, dynamic>>>.seeded({});
  final _uuid = Uuid();

  @override
  Stream<Map<String, Map<String, dynamic>>> observeAll() => _cache;

  Map<String, Map<String, dynamic>> get _objects => _cache.value;

  set _objects(Map<String, Map<String, dynamic>> objects) {
    _cache.add(objects);
  }

  @override
  Future<Map<String, dynamic>> read(String id) async => _objects[id];

  @override
  Future<Map<String, Map<String, dynamic>>> readAll() async => _objects;

  @override
  Future<String> save(Map<String, dynamic> object) async {
    final uuid = _uuid.v4();
    _objects = {
      ..._objects,
      uuid: object,
    };
    return uuid;
  }

  @override
  Future<void> update(String id, Map<String, dynamic> object) async {
    if (!_objects.containsKey(id)) {
      throw Exception('Object (id=$id) does not exist');
    } else {
      _objects = {
        ..._objects,
        id: object,
      };
    }
  }

  @override
  Future<void> delete(String id) async {
    _objects.remove(id);
  }

  @override
  Stream<Map<String, dynamic>> observeObject(String id) {
    return _cache
        .where((objects) => objects.containsKey(id))
        .map((objects) => objects[id]);
  }
}
