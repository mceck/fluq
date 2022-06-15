import 'package:fluq/fluq.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock.dart';

void main() {
  group('fluq provider widget', () {
    testWidgets('should mount', (tester) async {
      final q = MockQueryModel(1);
      await tester.pumpWidget(
        FluqProvider(
          child: Container(),
        ),
      );
    });
  });
}
