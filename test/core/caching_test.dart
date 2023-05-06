import 'package:flutter_test/flutter_test.dart';

import '../../core/caching.dart';

void main() {
  Caching caching = Caching(url: 'https://www.cloudskillsboost.google/public_profiles/89f7acf3-0eb5-42e3-b553-3e0132704026');
  test('test load', () async {
    await caching.load();
  });
}