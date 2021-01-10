# json_dao

A Dart's DAO abstraction that can be used with many db engines that enables storing data as JSON/Map structure.
Check it on: https://github.com/jarekb123/json_dao

# json_dao_test

Package that exposes testing helpers for implementations of `JsonDaoEngine` and `ReactiveDaoEngine` from `json_dao` package.

## How to use? (Example)

##  `JsonDaoEngine`

```dart
void main() {
  engineIntegrationTest(
    'MemoryDaoEngine tests',
    createEngine: () => MemoryDaoEngine(),
  );
}
```

## Reactive Extension - `ReactiveDaoEngine`
```dart
void main() {
  reactiveEngineIntegrationTest(
    'MemoryDaoEngine reactive tests',
    create: () => MemoryDaoEngine(),
  );
}
```