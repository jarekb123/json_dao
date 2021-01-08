# json_dao

A Dart's DAO abstraction that can be used with many db engines that enables storing data as JSON/Map structure.

## CrudJsonDao abstraction

`CrudJsonDao` exposes base CRUD methods:
* save
* get all 
* get by id
* update by id

## How to use?

### Create your models

> NOTE: In production app use immutable objects, eg. consider using Freezed package.

```dart
class Model {
    String name;    
}
```

### Create Mapper for your model
```dart
class ModelMapper implements Mapper<Model> {
    @override
    Model fromJson(Map<String, dynamic> json) {
        return Model()..name = json['name'];
    }

    @override
    Map<String, dynamic> toJson(Model model) {
        return { 'name': model.name };
    }
}
```

### Implement DAO (extend `CrudJsonDao`)

Rememeber about choosing dao engine that fulfills your needs, eg. `MemoryDaoEngine`

```dart
class ModelDao extends CrudJsonDao<Model> {
    @override
    Mapper<Model> get mapper => ModelMapper();

    @override
    JsonDaoEngine get engine => MemoryDaoEngine();
}
```

## Extensions

### Reactive Extensions

Reactive extension for CrudJsonDao enables:

* observing changes of all objects
* observing changes of one objects

To use reactive extension your engine needs to implement `ReactiveDaoEngine` mixin methods.

```dart

class ReactiveModelDao extends CrudJsonDao<Model> with ReactiveCrudJsonDao<Model> {
    @override
    Mapper<Model> get mapper => ModelMapper();

    @override
    ReactiveDaoEngine get engine => MemoryDaoEngine();
}

```