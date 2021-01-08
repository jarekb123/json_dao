import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_dao/json_dao_engine.dart';
import 'package:json_dao/reactive_dao.dart';
import 'package:meta/meta.dart';

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

@isTestGroup
void reactiveEngineIntegrationTest(
  Object description, {
  @required ReactiveDaoEngine Function() create,
  void Function() setUpTests,
  void Function() tearDownTests,
}) {
  group(
    description ?? 'Reactive DaoEngine',
    () {
      ReactiveDaoEngine reactiveDaoEngine;

      setUp(() {
        reactiveDaoEngine = create();
      });

      tearDown(() {
        tearDownTests?.call();
      });

      test(
        'observeAll() emits empty map if no changes were made immediately',
        () async {
          final firstValue = await reactiveDaoEngine.observeAll().first;

          expect(firstValue, {});
        },
      );
      test(
        'observeAll() emits values when values were added',
        () async {
          final emitted = [];
          reactiveDaoEngine.observeAll().listen(emitted.add);
          final id1 = await reactiveDaoEngine.save({'key': 'value1'});
          final id2 = await reactiveDaoEngine.save({'key': 'value2'});

          final expected = [
            {},
            {
              id1: {'key': 'value1'}
            },
            {
              id1: {'key': 'value1'},
              id2: {'key': 'value2'},
            },
          ];

          expect(emitted, expected);
        },
      );

      test(
        'observeObject(id) emits changes of an object',
        () async {
          final id = await reactiveDaoEngine.save({'key': 'value1'});
          final emitted = [];
          reactiveDaoEngine.observeObject(id).listen(emitted.add);

          await Future.delayed(Duration.zero);
          await reactiveDaoEngine.update(id, {'key': 'value2'});
          await Future.delayed(Duration.zero);
          await reactiveDaoEngine.update(id, {'key': 'value3'});
          await Future.delayed(Duration.zero);

          final expected = [
            {'key': 'value1'},
            {'key': 'value2'},
            {'key': 'value3'},
          ];
          expect(emitted, expected);
        },
      );
    },
  );
}
