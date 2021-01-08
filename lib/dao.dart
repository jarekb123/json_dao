import 'dto.dart';
import 'json_dao_engine.dart';
import 'mapper.dart';

abstract class CrudJsonDao<Model> {
  JsonDaoEngine get engine;
  Mapper<Model> get mapper;

  Future<Dto<Model>> read(String id) async {
    return Dto(id, mapper.fromMap(await engine.read(id)));
  }

  Future<String> save(Model model) => engine.save(mapper.toMap(model));

  Future<Iterable<Dto<Model>>> readAll() async {
    final rawObjects = await engine.readAll();

    return rawObjects.entries.map(
        (rawObject) => Dto(rawObject.key, mapper.fromMap(rawObject.value)));
  }

  Future<void> delete(String id) => engine.delete(id);

  Future<void> update(String id, Model model) =>
      engine.update(id, mapper.toMap(model));
}
