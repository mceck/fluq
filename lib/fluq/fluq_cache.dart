import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluq/fluq/query_model.dart';
import 'package:rxdart/subjects.dart';

import 'package:fluq/fluq/query_stream.dart';
import 'package:fluq/fluq/query_state.dart';

/// Fluq instance
class Fluq {
  final Map<dynamic, QueryStream> _queryCache = HashMap<dynamic, QueryStream>();

  BehaviorSubject<QueryState> getQueryStream(dynamic id) =>
      _queryCache[id]?.stream;

  /// use to programmatically fetch a query model and create the relative stream if not exist
  /// if the stream already exist it will do nothing
  void prefetch(QueryModel query) {
    if (_queryCache.containsKey(query.key)) return;
    _queryCache[query.key] = QueryStream(
      (BehaviorSubject stream) {
        stream.add(QueryLoading());
        return _fetchData(query.fetch, stream);
      },
    );
  }

  /// use to emit/update a specific query state on a stream
  /// pass the key of the query to update state and the new state
  void setQueryState(key, QueryState state) {
    assert(_queryCache.containsKey(key));
    _queryCache[key].stream.add(state);
  }

  /// use to invalidate all query stream and force to refetch of all of them
  void invalidateAllQuery() {
    _queryCache.keys.forEach((key) {
      invalidateQuery(key);
    });
  }

  /// use to invalidate a single query stream and force to refetch
  /// pass the query key as parameter
  void invalidateQuery(key) {
    _queryCache[key].fetch();
  }

  /// dispose a query by passing the key
  void disposeStream(key) {
    assert(_queryCache.containsKey(key));
    _queryCache[key].dispose();
    _queryCache.remove(key);
  }

  /// dispose all the queries
  void dispose() {
    _queryCache.forEach((_, apiStream) {
      apiStream.dispose();
    });
    _queryCache.clear();
  }

  /// use to access the Fluq instance passing the context
  static Fluq of(BuildContext context) =>
      Provider.of<Fluq>(context, listen: false);

  Future<void> _fetchData(Future Function() fetch, BehaviorSubject stream) {
    return fetch()
        .then(
          (data) => stream.add(
            QueryResult(data),
          ),
        )
        .catchError((err) => stream.add(QueryError(err)));
  }
}
