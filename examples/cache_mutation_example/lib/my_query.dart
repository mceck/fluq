import 'package:fluq/fluq.dart';

class MyQuery extends QueryModel {
  get key => "my-query";

  @override
  Future fetch([Map<String, dynamic> params]) async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'result': 'apiTestResult',
    };
  }
}
