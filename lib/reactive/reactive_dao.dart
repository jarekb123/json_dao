import 'package:json_dao/dao.dart';
import 'package:json_dao/dto.dart';

import 'reactive_dao_engine.dart';

mixin ReactiveCrudJsonDao<Model> on CrudJsonDao<Model> {
  @override
  ReactiveDaoEngine get engine;

  Stream<Iterable<Dto<Model>>> observeAll() {
    return engine.observeAll().map((objectsMap) => objectsMap.entries.map(
          (rawObject) => Dto(
            rawObject.key,
            mapper.fromMap(rawObject.value),
          ),
        ));
  }

  Stream<Model> observeObject(String id) =>
      engine.observeObject(id).map(mapper.fromMap);
}
