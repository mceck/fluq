import 'package:fluq/fluq.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fluq query state', () {
    test('create loading state', () {
      QueryLoading();
    });

    test('create error state', () {
      final err1 = QueryError(1);
      final err2 = QueryError('1');

      expect(err1.error, 1);
      expect(err2.error, '1');
    });

    test('create result state', () {
      final res1 = QueryResult(1);
      final res2 = QueryResult('1');

      expect(res1.data, 1);
      expect(res2.data, '1');
    });
  });
}
