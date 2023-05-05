import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../core/config_loader.dart';

void main() {
  dynamic configs;
  test('read configs', () async {
    configs = await const ConfigLoader(path: 'config/quanquangcp5.json').value;
  });
  test('name', () async {
    expect(configs['name'], equals('QuanQuanGCP5'));
  });
  test('start', () async {
    expect(configs['start'], equals('31/03/2023 00:00:00'));
  });
  test('end', () async {
    expect(configs['end'], equals('29/04/2023 23:59:59'));
  });
  test('check section and type', () async {
    final section = configs['section'] as List;
    final type = configs['type'] as List;
    for (var s in section) {
      for (var t in type) {
        expect(configs['quests'][s][t] != null, equals(true));
      }}
  });
  test('empty file', () async {
    File file = await File('.tmp/config_loader_test.json').create(recursive: true);
    expect(() async {
      configs = await const ConfigLoader(path: '.tmp/config_loader_test.json').value;
    }, throwsException);
    await file.delete();
  });
}