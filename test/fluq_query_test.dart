import 'package:fluq/fluq.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock.dart';

void main() {
  group('fluq query widget', () {
    testWidgets('should mount', (tester) async {
      final q = MockQueryModel(1);
      await tester.pumpWidget(
        FluqProvider(
          child: QueryBuilder(
            query: q,
            builder: (context, state) => Container(),
          ),
        ),
      );
    });

    testWidgets('shold not mount without provider', (tester) async {
      final q = MockQueryModel(1);
      await tester.pumpWidget(
        QueryBuilder(
          query: q,
          builder: (context, state) => Container(),
        ),
      );
      expect(tester.takeException(), isException);
    });

    testWidgets('should start in loading state', (tester) async {
      final q = MockQueryModel(1);
      await tester.pumpWidget(
        FluqProvider(
          child: QueryBuilder(
            query: q,
            builder: (context, state) {
              return MockStateWidget(state: state);
            },
          ),
        ),
      );
      var finder = find.text('loading');
      expect(finder, findsOneWidget);
    });
  });
}
