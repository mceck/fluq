import 'package:fluq/fluq.dart';

class MyQuery extends QueryModel {
  @override
  get key => "my-query";

  @override
  Future fetch() async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'result': 'apiTestResult',
    };
  }
}
