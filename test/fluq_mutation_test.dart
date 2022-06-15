import 'package:fluq/fluq.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('fluq mutation widget', () {
    testWidgets('should mount', (tester) async {
      await tester.pumpWidget(
        FluqProvider(
          child: Mutation(
            builder: (context, state) => Container(),
            fetch: (Fluq cache) async {},
          ),
        ),
      );
    });
  });
}
