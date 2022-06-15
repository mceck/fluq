import 'package:flutter/foundation.dart';

/// extend this class to declare your queries
/// implement the key getter returning an unique id for the query
/// implement the fetch method returning data or errors
@immutable
abstract class QueryModel<ParamType, ResultType> {
  final String _key;
  final ParamType? parameter;

  String get key => _key + (parameter?.hashCode.toString() ?? '');

  QueryModel(this._key, {this.parameter});

  Future<ResultType> fetch();

  @override
  bool operator ==(Object o) {
    if (o is QueryModel) {
      return o.key == key;
    }
    return false;
  }

  @override
  int get hashCode => key.hashCode;
}
