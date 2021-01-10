import 'package:json_dao/reactive/reactive_dao_engine.dart';
import 'package:meta/meta.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:json_dao/json_dao_engine.dart';

class HiveDaoEngine implements JsonDaoEngine {
  final HiveInterface _hive;
  final String _boxName;
  final Uuid _uuid;

  HiveDaoEngine(this._boxName)
      : _hive = Hive,
        _uuid = Uuid();

  @visibleForTesting
  HiveDaoEngine.create(this._hive, this._boxName, this._uuid);

  Future<Box<Map<String, dynamic>>> get _box =>
      _hive.openBox<Map<String, dynamic>>(_boxName);

  @override
  Future<Map<String, dynamic>> read(String id) async {
    return (await _box).get(id);
  }

  @override
  Future<Map<String, Map<String, dynamic>>> readAll() async {
    return _getMapOfKeysValues(await _box);
  }

  @override
  Future<String> save(Map<String, dynamic> object) async {
    final uuid = _uuid.v4();
    await (await _box).put(uuid, object);
    return uuid;
  }

  @override
  Future<void> delete(String id) async {
    return (await _box).delete(id);
  }

  @override
  Future<void> update(String id, Map<String, dynamic> object) async {
    (await _box).put(id, object);
  }
}

Map<String, Map<String, dynamic>> _getMapOfKeysValues(
  Box<Map<String, dynamic>> box,
) {
  return box.toMap().map((key, value) => MapEntry(key.toString(), value));
}

class ReactiveHiveDaoEngine = HiveDaoEngine with _ReactiveHiveDaoEngineMixin;

mixin _ReactiveHiveDaoEngineMixin on HiveDaoEngine
    implements ReactiveDaoEngine {
  @override
  Stream<Map<String, Map<String, dynamic>>> observeAll() {
    return _box.asStream().switchMap<Map<String, Map<String, dynamic>>>((box) {
      final objectsUpdates = box.watch().asyncMap((_) => readAll());
      final currentObjects = _getMapOfKeysValues(box);

      return objectsUpdates.startWith(currentObjects);
    });
  }

  @override
  Stream<Map<String, dynamic>> observeObject(String id) async* {
    final box = await _box;

    yield* box
        .watch(key: id)
        .map((_) => box.get(id))
        .startWith(box.get(id))
        .where((object) => object != null);
  }
}
