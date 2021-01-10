# json_dao

A Dart's DAO abstraction that can be used with many db engines that enables storing data as JSON/Map structure.
Check it on: https://github.com/jarekb123/json_dao

# hive_engine_json_dao

Package that contains Hive implementation of `JsonDaoEngine` and `ReactiveDaoEngine` from `json_dao` package.

## How to use? (Example)

`HiveDaoEngine` implements methods of `JsonDaoEngine` and `ReactiveDaoEngine`.

#### CrudJsonDao

```dart
class ModelDao extends CrudJsonDao<Model> {
    @override
    Mapper<Model> get mapper => ModelMapper();

    @override
    JsonDaoEngine get engine => HiveDaoEngine('HiveBoxName');
}
```

#### ReactiveCrudJsonDao

```dart
class ModelDao extends CrudJsonDao<Model> with ReactiveCrudJsonDao<Model> {
    @override
    Mapper<Model> get mapper => ModelMapper();

    @override
    ReactiveDaoEngine get engine => HiveDaoEngine('HiveBoxName');
}
```