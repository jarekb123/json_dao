import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:json_dao/implementations/hive_dao_engine.dart';

import '../base_engine_integration_tester.dart';
import '../reactive/reactive_engine_tester.dart';

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
  setUpAll(() {
    final testBoxesDir = Directory(_testBoxesPath);
    if (testBoxesDir.existsSync()) {
      testBoxesDir.deleteSync(recursive: true);
    }
    Hive.init(_testBoxesPath);
  });

  tearDownAll(() async {
    Directory(_testBoxesPath).deleteSync();
  });

  engineIntegrationTest(
    createEngine: () => HiveDaoEngine('TestBox'),
    tearDownTests: () => Hive.deleteBoxFromDisk('TestBox'),
    description: 'HiveDaoEngine tests',
  );

  reactiveEngineIntegrationTest(
    'ReactiveHiveDaoEngine tests',
    create: () => ReactiveHiveDaoEngine('ReactiveTestBox'),
    tearDownTests: () => Hive.deleteBoxFromDisk('ReactiveTestBox'),
  );
}
