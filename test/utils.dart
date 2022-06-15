import 'package:fluq/fluq.dart';
import 'package:rxdart/subjects.dart';
import 'package:flutter_test/flutter_test.dart';

BehaviorSubject<QueryState> getStream(Fluq f, QueryModel q) {
  f.prefetch(q);
  final stream = f.getQueryStream(q.key);
  expect(stream != null, true);
  return stream!;
}

Future<void> testLoading(BehaviorSubject<QueryState> stream) async {
  final loading = await stream.first;
  expect(loading is QueryLoading, true);
}

Future<void> testResult(
    BehaviorSubject<QueryState> stream, int expectedResult) async {
  final res = await stream.first;
  expect(res is QueryResult, true);
  expect((res as QueryResult).data, expectedResult);
}

Future<void> testError(
    BehaviorSubject<QueryState> stream, dynamic expectedResult) async {
  final res = await stream.first;
  expect(res is QueryError, true);
  expect((res as QueryError).error.toString(), 'Exception: ' + expectedResult);
}
