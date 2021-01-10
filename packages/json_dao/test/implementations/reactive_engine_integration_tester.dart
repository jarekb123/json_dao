import 'package:json_dao/reactive/reactive_dao_engine.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

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
