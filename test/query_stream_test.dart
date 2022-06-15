import 'package:fluq/fluq.dart';
import 'package:fluq/fluq/query_stream.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock.dart';
import 'utils.dart';

void main() {
  group('fluq query stream', () {
    test('should init and fetch', () async {
      final qs = QueryStream((_) => Future.value(1));
      final res = await qs.fetch();
      expect(res, 1);
      qs.dispose();
    });

    test('should init with stream and check emitted values', () async {
      QueryStream((stream) async {
        stream.add(QueryResult(1));
        testResult(stream, 1);
      });
    });

    test('should init with stream without autofetch and check emitted values',
        () async {
      final qs = QueryStream((stream) async {
        throw Exception('error');
      }, autoFetch: false);

      try {
        await qs.fetch();
        // should not run
        expect(true, false);
      } catch (e) {
        expect(e.toString(), 'Exception: error');
      }
    });
  });
}
