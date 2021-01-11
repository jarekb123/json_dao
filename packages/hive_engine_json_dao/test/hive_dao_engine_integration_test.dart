import 'package:hive/hive.dart';
import 'package:hive_engine_json_dao/hive_dao_engine.dart';
import 'package:test/test.dart';

import 'package:json_dao_test/engine_integration_tester.dart';
import 'package:json_dao_test/reactive_engine_integration_tester.dart';

void main() {
  setUpAll(() {});

  tearDownAll(() async {});

  engineIntegrationTest(
    'HiveDaoEngine tests',
    createEngine: () {
      Hive.init('./hive_test_boxes');
      return HiveDaoEngine('TestBox');
    },
    tearDownTests: () {
      Hive.deleteBoxFromDisk('TestBox');
    },
  );

  reactiveEngineIntegrationTest(
    'ReactiveHiveDaoEngine tests',
    create: () {
      Hive.init('./hive_test_boxes');
      return ReactiveHiveDaoEngine('ReactiveTestBox');
    },
    tearDownTests: () => Hive.deleteBoxFromDisk('ReactiveTestBox'),
  );
}
