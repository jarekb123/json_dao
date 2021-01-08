import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:json_dao/implementations/hive_dao_engine.dart';

class _MockHiveBox extends Mock implements Box<Map<String, dynamic>> {}

class _MockHive extends Mock implements HiveInterface {}

class _MockUuid extends Mock implements Uuid {}

void main() {
  _MockHiveBox mockHiveBox;
  _MockUuid mockUuid;
  HiveDaoEngine hiveDaoEngine;

  const testBox = 'testBox';

  setUpAll(() {
    mockHiveBox = _MockHiveBox();
    mockUuid = _MockUuid();
  });

  group(
    'HiveDaoEngine',
    () {
      setUpAll(() {
        final mockHive = _MockHive();
        hiveDaoEngine = HiveDaoEngine.create(mockHive, testBox, mockUuid);
        when(mockHive.openBox(testBox)).thenAnswer((_) async => mockHiveBox);
      });

      test('read(id) gets value which key == id', () async {
        when(mockHiveBox.get('UUID')).thenReturn({'key': 'value'});
        final data = await hiveDaoEngine.read('UUID');
        expect(data, {'key': 'value'});
      });

      test('readAll() merges value and their keys', () async {
        when(mockHiveBox.toMap()).thenReturn(
          {
            '1': {'key': 'value1'},
            '2': {'key': 'value2'}
          },
        );

        final data = await hiveDaoEngine.readAll();

        expect(data, {
          '1': {'key': 'value1'},
          '2': {'key': 'value2'}
        });
      });

      test(
        'save(map) puts map with auto generated uuid v4',
        () async {
          final map = {'key': 'value'};
          when(mockUuid.v4()).thenReturn('UUID');

          final createdMapId = await hiveDaoEngine.save(map);
          expect(createdMapId, 'UUID');
        },
      );

      test(
        'update(id, map) updates exisiting map',
        () async {
          final map = {'key': 'value'};

          await hiveDaoEngine.update('uuid', map);
          verify(mockHiveBox.put('uuid', map));
        },
      );

      test(
        'delete(id) deletes object which key.toString() == id',
        () async {
          await hiveDaoEngine.delete('1234');

          verify(mockHiveBox.delete('1234')).called(1);
        },
      );
    },
  );

  group(
    'ReactiveHiveDaoEngine',
    () {
      ReactiveHiveDaoEngine reactiveHiveDaoEngine;

      setUp(() {
        final mockHive = _MockHive();
        final Box<Map<String, dynamic>> box = mockHiveBox;
        when(mockHive.openBox<Map<String, dynamic>>(testBox))
            .thenAnswer((_) async => box);
        reactiveHiveDaoEngine =
            ReactiveHiveDaoEngine.create(mockHive, testBox, mockUuid);
      });

      test(
        'observeAll() emits merged values and keys '
        'then emits all values on every box event',
        () {
          when(mockHiveBox.toMap()).thenReturn(
            {
              '1': {'key': 'value1'},
              '2': {'key': 'value2'}
            },
          );

          when(mockHiveBox.watch()).thenAnswer((_) {
            return Stream.value(BoxEvent(1, {'key': 'value123'}, false))
                .doOnListen(
              () {
                when(mockHiveBox.toMap()).thenReturn(
                  {
                    '1': {'key': 'value123'},
                    '2': {'key': 'value2'}
                  },
                );
              },
            );
          });

          expect(
            reactiveHiveDaoEngine.observeAll(),
            emitsInOrder(
              [
                {
                  '1': {'key': 'value1'},
                  '2': {'key': 'value2'}
                },
                {
                  '1': {'key': 'value123'},
                  '2': {'key': 'value2'}
                },
              ],
            ),
          );
        },
      );
    },
  );
}
