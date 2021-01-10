import 'dart:io';

import 'package:hive/hive.dart';
import 'package:hive_engine_json_dao/hive_dao_engine.dart';
import 'package:test/test.dart';

import 'package:json_dao_test/engine_integration_tester.dart';
import 'package:json_dao_test/reactive_engine_integration_tester.dart';

// From: https://github.com/terryx/flutter-muscle/blob/master/github_provider/test/utils/test_path.dart
String testPath(String relativePath) {
  //Fix vscode test path
  final Directory current = Directory.current;
  final String path =
      current.path.endsWith('/test') ? current.path : '${current.path}/test';

  return '$path/$relativePath';
}

final _testBoxesPath = testPath('hive_test_boxes');

void main() {
  setUpAll(() {});

  tearDownAll(() async {});

  engineIntegrationTest(
    'HiveDaoEngine tests',
    createEngine: () {
      Hive.init(_testBoxesPath);
      return HiveDaoEngine('TestBox');
    },
    tearDownTests: () {
      Hive.deleteBoxFromDisk('TestBox');
    },
  );

  reactiveEngineIntegrationTest(
    'ReactiveHiveDaoEngine tests',
    create: () {
      Hive.init(_testBoxesPath);
      return ReactiveHiveDaoEngine('ReactiveTestBox');
    },
    tearDownTests: () => Hive.deleteBoxFromDisk('ReactiveTestBox'),
  );
}
