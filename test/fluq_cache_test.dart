import 'package:fluq/fluq.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock.dart';
import 'utils.dart';

void main() {
  group('fluq cache', () {
    Fluq? fluq;

    setUp(() {
      fluq = Fluq();
    });

    tearDown(() {
      fluq?.dispose();
    });

    test('should create instance without errors', () {
      expect(fluq != null, true);
    });

    test('should create a stream and check the emitted values', () async {
      final q = MockQueryModel(1);
      final stream = getStream(fluq!, q);
      await testLoading(stream);
      await testResult(stream, 1);
    });

    test('should create 2 stream and check cache consistency', () async {
      final q1 = MockQueryModel(1);
      final q2 = MockQueryModel(2);
      var stream1 = getStream(fluq!, q1);
      await testLoading(stream1);
      await testResult(stream1, 1);
      var stream2 = getStream(fluq!, q2);
      await testLoading(stream2);
      await testResult(stream2, 2);

      stream1 = getStream(fluq!, q2);
      await testResult(stream1, 2);
      stream2 = getStream(fluq!, q1);
      await testResult(stream2, 1);
    });

    test('should redo fetch after single cache invalidation', () async {
      final q = MockQueryModel(1);
      var stream = getStream(fluq!, q);
      await testLoading(stream);
      await testResult(stream, 1);
      fluq!.invalidateQuery(q.key);
      await testLoading(stream);
      await testResult(stream, 1);
    });

    test('should redo fetch after all cache invalidation', () async {
      final q1 = MockQueryModel(1);
      final q2 = MockQueryModel(2);
      var stream1 = getStream(fluq!, q1);
      await testLoading(stream1);
      await testResult(stream1, 1);
      var stream2 = getStream(fluq!, q2);
      await testLoading(stream2);
      await testResult(stream2, 2);

      fluq!.invalidateAllQuery();
      await testLoading(stream1);
      await testResult(stream1, 1);
      await testResult(stream2, 2);

      fluq!.invalidateAllQuery();
      await testLoading(stream2);
      await testResult(stream1, 1);
      await testResult(stream2, 2);
    });

    test('should emit error', () async {
      final q = MockErrorQueryModel('error');
      final stream = getStream(fluq!, q);
      await testLoading(stream);
      await testError(stream, 'error');
    });

    test('should force query state', () async {
      final q = MockQueryModel(1);
      final stream = getStream(fluq!, q);
      await testLoading(stream);
      await testResult(stream, 1);
      fluq!.setQueryState(q.key, QueryResult(2));
      await testResult(stream, 2);
      fluq!.setQueryState(q.key, QueryLoading());
      await testLoading(stream);
      fluq!.setQueryState(q.key, QueryError(Exception('error')));
      await testError(stream, 'error');
    });

    test('should auto invalidate after error', () async {
      final q = MockQueryModel(1);
      var stream = getStream(fluq!, q);
      await testLoading(stream);
      fluq!.setQueryState(q.key, QueryError(Exception('error')));
      await testError(stream, 'error');
      stream = getStream(fluq!, q);
      await testLoading(stream);
      await testResult(stream, 1);
    });
  });
}
