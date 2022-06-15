import 'package:fluq/fluq.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock.dart';

void main() {
  group('fluq query model', () {
    test('should create and fetch a model', () async {
      final model = MockQueryModel(1);
      expect(model.parameter, 1);
      expect(await model.fetch(), 1);
    });

    test('should create and fetch with error', () async {
      final model = MockErrorQueryModel('error');
      expect(model.parameter, null);
      try {
        await model.fetch();
        expect(true, false);
      } catch (e) {
        expect(e.toString(), 'Exception: error');
      }
    });
  });
}
