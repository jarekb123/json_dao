import 'package:mockito/mockito.dart';
import 'package:json_dao/json_dao_engine.dart';
import 'package:json_dao/mapper.dart';

class TestModel {
  final String value;

  const TestModel(this.value);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TestModel && o.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'TestModel(value: $value)';
}

class TestModelMapper implements Mapper<TestModel> {
  @override
  TestModel fromMap(Map<String, dynamic> map) {
    return TestModel(map['value'].toString());
  }

  @override
  Map<String, dynamic> toMap(TestModel model) {
    return {'value': model.value};
  }
}

class MockDaoEngine extends Mock implements JsonDaoEngine {}
