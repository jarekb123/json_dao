import 'package:mockito/mockito.dart';

import 'package:json_dao/dao.dart';
import 'package:json_dao/dto.dart';
import 'package:json_dao/json_dao_engine.dart';
import 'package:json_dao/mapper.dart';
import 'package:test/test.dart';

import 'mocks.dart';

class TestJsonDao extends CrudJsonDao<TestModel> {
  @override
  final JsonDaoEngine engine;

  TestJsonDao(this.engine);

  @override
  Mapper<TestModel> get mapper => TestModelMapper();
}

void main() {
  MockDaoEngine mockDaoEngine;
  TestJsonDao testJsonDao;

  setUpAll(() {
    mockDaoEngine = MockDaoEngine();
    testJsonDao = TestJsonDao(mockDaoEngine);
  });

  test(
    'read(id) reads and maps value from engine',
    () async {
      when(mockDaoEngine.read('ID')).thenAnswer((_) async => {'value': 'data'});

      final dto = await testJsonDao.read('ID');
      expect(dto.id, 'ID');
      expect(dto.data.value, 'data');
    },
  );

  test(
    'save(object) maps and saves object using engine ',
    () async {
      await testJsonDao.save(const TestModel('test_data'));
      verify(mockDaoEngine.save({'value': 'test_data'}));
    },
  );

  test(
    'readAll fetches all objects from engine',
    () async {
      when(mockDaoEngine.readAll()).thenAnswer((_) async {
        return {
          'id_1': {'value': 'value1'},
          'id_2': {'value': 'value2'},
        };
      });
      final objects = await testJsonDao.readAll();
      expect(objects.toList(), const [
        Dto('id_1', TestModel('value1')),
        Dto('id_2', TestModel('value2')),
      ]);
    },
  );

  test(
    'delete(id) deletes object using engine',
    () async {
      await testJsonDao.delete('ID');
      verify(mockDaoEngine.delete('ID')).called(1);
    },
  );
}
