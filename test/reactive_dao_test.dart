import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:json_dao/dao.dart';
import 'package:json_dao/dto.dart';
import 'package:json_dao/mapper.dart';
import 'package:json_dao/reactive_dao.dart';

import 'mocks.dart';

class MockReactiveDaoEngine = MockDaoEngine with ReactiveDaoEngine;

class TestReactiveJsonDao extends CrudJsonDao<TestModel>
    with ReactiveCrudJsonDao {
  @override
  final ReactiveDaoEngine engine;

  TestReactiveJsonDao(this.engine);

  @override
  Mapper<TestModel> get mapper => TestModelMapper();
}

void main() {
  MockReactiveDaoEngine mockReactiveDaoEngine;
  TestReactiveJsonDao testReactiveJsonDao;

  setUp(() {
    testReactiveJsonDao = TestReactiveJsonDao(
      mockReactiveDaoEngine = MockReactiveDaoEngine(),
    );
  });

  test(
    'observeAll() observes and maps (with mapper) raw map objects '
    'emitted by engine',
    () {
      when(mockReactiveDaoEngine.observeAll()).thenAnswer(
        (_) => Stream.fromIterable(
          [
            {
              '1': {'value': 'value1'},
              '2': {'value': 'value2'},
            },
            {
              '1': {'value': 'value1'},
              '2': {'value': 'value2'},
              '3': {'value': 'value3'},
            },
          ],
        ),
      );

      const expected = [
        [
          Dto('1', TestModel('value1')),
          Dto('2', TestModel('value2')),
        ],
        [
          Dto('1', TestModel('value1')),
          Dto('2', TestModel('value2')),
          Dto('3', TestModel('value3')),
        ]
      ];
      expect(testReactiveJsonDao.observeAll(), emitsInOrder(expected));
    },
  );
}
