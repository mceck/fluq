import 'package:flutter/material.dart';

@immutable
abstract class QueryState {}

class QueryLoading extends QueryState {}

class QueryError extends QueryState {
  final dynamic error;

  QueryError(this.error);
}

class QueryResult<T> extends QueryState {
  final T data;

  QueryResult(this.data);
}
