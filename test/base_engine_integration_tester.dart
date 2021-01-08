import 'package:json_dao/json_dao_engine.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

@isTestGroup
void engineIntegrationTest({
  @required JsonDaoEngine Function() createEngine,
  void Function() setUpTests,
  void Function() tearDownTests,
  Object description,
}) {
  group(
    description ?? 'DaoEngine',
    () {
      JsonDaoEngine jsonDaoEngine;

      setUpAll(() {
        setUpTests?.call();
        jsonDaoEngine = createEngine();
      });

      tearDownAll(() {
        tearDownTests?.call();
      });

      test(
        'added value can be fetched by id',
        () async {
          final id = await jsonDaoEngine.save({'key': 'value'});
          final result = await jsonDaoEngine.read(id);
          const expected = {'key': 'value'};

          expect(result, expected);
        },
      );

      test(
        'added value can be removed by id',
        () async {
          final id = await jsonDaoEngine.save({'key': 'value'});
          await jsonDaoEngine.delete(id);

          final result = await jsonDaoEngine.read(id);

          expect(result, isNull);
        },
      );

      test(
        'added objects can be retrieved from list of all objects',
        () async {
          final id1 = await jsonDaoEngine.save({'key': 'data'});
          final id2 = await jsonDaoEngine.save({'username': 'some_username'});

          final allObjects = await jsonDaoEngine.readAll();
          expect(allObjects, containsPair(id1, {'key': 'data'}));
          expect(allObjects, containsPair(id2, {'username': 'some_username'}));
        },
      );

      test(
        'added object can be updated by id',
        () async {
          final id = await jsonDaoEngine.save({'key': 'data'});
          // check added object
          final result = await jsonDaoEngine.read(id);
          const expected = {'key': 'data'};
          expect(result, expected);

          await jsonDaoEngine.update(id, {'key': 'value'});
          // check updated object
          final updated = await jsonDaoEngine.read(id);
          const expectedUpdatedValue = {'key': 'value'};
          expect(updated, expectedUpdatedValue);
        },
      );
    },
  );
}
