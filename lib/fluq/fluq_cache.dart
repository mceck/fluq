import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluq/fluq/query_model.dart';
import 'package:rxdart/subjects.dart';

import 'package:fluq/fluq/query_stream.dart';
import 'package:fluq/fluq/query_state.dart';

class Fluq {
  final Map<dynamic, QueryStream> _queryCache = HashMap<dynamic, QueryStream>();

  BehaviorSubject<QueryState> getQueryStream(dynamic id) =>
      _queryCache[id]?.stream;

  void prefetch(QueryModel query) {
    if (_queryCache.containsKey(query.key)) return;
    _queryCache[query.key] = QueryStream(
      (BehaviorSubject stream) {
        stream.add(QueryLoading());
        return _fetchData(query.fetch, stream);
      },
    );
  }

  void invalidateAllQuery() {
    _queryCache.keys.forEach((key) {
      invalidateQuery(key);
    });
  }

  void invalidateQuery(key) {
    _queryCache[key].fetch();
  }

  void disposeStream(key) {
    assert(_queryCache.containsKey(key));
    _queryCache[key].dispose();
    _queryCache.remove(key);
  }

  void setQueryState(key, QueryState state) {
    assert(_queryCache.containsKey(key));
    _queryCache[key].stream.add(state);
  }

  void dispose() {
    _queryCache.forEach((_, apiStream) {
      apiStream.dispose();
    });
    _queryCache.clear();
  }

  Future<void> _fetchData(Future Function() fetch, BehaviorSubject stream) {
    return fetch()
        .then(
          (data) => stream.add(
            QueryResult(data),
          ),
        )
        .catchError((err) => stream.add(QueryError(err)));
  }

  static Fluq of(BuildContext context) =>
      Provider.of<Fluq>(context, listen: false);

  static Future<T> mutate<T>(
    BuildContext context, {
    Future<T> Function() fetch,
    void Function(Fluq cache, T result) update,
    void Function(T result) onSuccess,
    void Function(dynamic error) onError,
  }) {
    return fetch().then((data) {
      if (onSuccess != null) onSuccess(data);
      if (update != null) update(of(context), data);
      return data;
    }).catchError((err) {
      if (onError != null) onError(err);
    });
  }
}
