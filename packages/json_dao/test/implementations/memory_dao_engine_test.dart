import 'package:json_dao/implementations/memory_dao_engine.dart';

import 'engine_integration_tester.dart';
import 'reactive_engine_integration_tester.dart';

void main() {
  engineIntegrationTest(
    'MemoryDaoEngine tests',
    createEngine: () => MemoryDaoEngine(),
  );

  reactiveEngineIntegrationTest(
    'MemoryDaoEngine reactive tests',
    create: () => MemoryDaoEngine(),
  );
}
