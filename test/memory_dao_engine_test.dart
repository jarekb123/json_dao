import 'package:json_dao/memory_dao_engine.dart';

import 'base_engine_integration_tester.dart';

void main() {
  engineIntegrationTest(
    createEngine: () => MemoryDaoEngine(),
    description: 'MemoryDaoEngine tests',
  );

  reactiveEngineIntegrationTest(
    'MemoryDaoEngine reactive tests',
    create: () => MemoryDaoEngine(),
  );
}
