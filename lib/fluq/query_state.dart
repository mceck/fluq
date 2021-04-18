import 'package:flutter/material.dart';

// generic query state
@immutable
abstract class QueryState {}

/// State used for loading state
/// it will be the inital state when every query stream is created
/// it will be the inital state when every query stream is invalidated
class QueryLoading extends QueryState {}

/// State used for loading state
/// it will be emitted when there is a catched error on the query fetch function
/// it contains the error catched in the query fetch function
class QueryError extends QueryState {
  final dynamic error;

  QueryError(this.error);
}

/// State used for emitting the response data of the query
/// it contains the returned value fron the query fetch function
class QueryResult<T> extends QueryState {
  final T data;

  QueryResult(this.data);
}
