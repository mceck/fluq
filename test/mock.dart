import 'package:fluq/fluq.dart';
import 'package:flutter/material.dart';

class MockQueryModel extends QueryModel<int, int> {
  MockQueryModel(int parameter) : super('mock', parameter: parameter);

  @override
  Future<int> fetch() async {
    return this.parameter ?? -1;
  }
}

class MockErrorQueryModel extends QueryModel<int, int> {
  final String error;
  MockErrorQueryModel(this.error) : super('mock-error');

  @override
  Future<int> fetch() async {
    throw new Exception(error);
  }
}

class MockStateWidget extends StatelessWidget {
  final QueryState? state;
  const MockStateWidget({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state is QueryError) {
      return Text('error  ${(state as QueryError).error}',
          textDirection: TextDirection.ltr);
    }
    if (state is QueryLoading) {
      return Text('loading', textDirection: TextDirection.ltr);
    }
    if (state is QueryResult) {
      return Text('result ${(state as QueryResult).data}',
          textDirection: TextDirection.ltr);
    }
    return Text('unknown');
  }
}
