import 'package:rxdart/rxdart.dart';
import 'package:fluq/fluq/query_state.dart';

/// class used behind to store every query stream and fetch funcion
class QueryStream<ResultType> {
  final BehaviorSubject<QueryState> stream = BehaviorSubject<QueryState>();
  final Future<ResultType> Function(BehaviorSubject<QueryState> stream) _fetch;

  Future<ResultType> fetch() => _fetch(stream);

  void dispose() {
    stream.close();
  }

  QueryStream(this._fetch, {bool autoFetch = true}) {
    if (autoFetch == true) fetch();
  }
}
