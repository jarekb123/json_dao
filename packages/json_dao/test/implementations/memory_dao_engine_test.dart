import 'package:json_dao/implementations/memory_dao_engine.dart';

import 'engine_integration_tester.dart';
import 'reactive_engine_integration_tester.dart';

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
