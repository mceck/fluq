import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluq/fluq/query_state.dart';
import 'package:fluq/fluq/query_model.dart';
import 'package:fluq/fluq/fluq_cache.dart';

/// Use this widget to access a query result reactively to state changes
///
/// pass your query model as parameter
/// pass a builder for rendering your data reactively to state changes
/// optionally pass a listener function to handle state changes
class QueryBuilder<ResultType> extends StatefulWidget {
  final QueryModel<dynamic, ResultType> query;
  final Widget Function(BuildContext context, QueryState? state) builder;
  final Widget Function(BuildContext context, QueryState state)? listener;

  const QueryBuilder({
    Key? key,
    required this.query,
    required this.builder,
    this.listener,
  }) : super(key: key);

  @override
  _QueryBuilderState<ResultType> createState() =>
      _QueryBuilderState<ResultType>();
}

class _QueryBuilderState<ResultType> extends State<QueryBuilder<ResultType>> {
  StreamSubscription? _listenerSub;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _update();
  }

  @override
  void didUpdateWidget(covariant QueryBuilder<ResultType> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _update();
  }

  @override
  void dispose() {
    _listenerSub?.cancel();
    super.dispose();
  }

  void _update() {
    final fluq = Fluq.of(context);
    fluq.prefetch(widget.query);
    if (widget.listener != null) {
      _listenerSub?.cancel();
      _listenerSub = fluq.getQueryStream(widget.query.key)!.listen((value) {
        widget.listener!(context, value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fluq = Fluq.of(context);
    return StreamBuilder<QueryState>(
        stream: fluq.getQueryStream(widget.query.key),
        builder: (context, snap) {
          if (snap.hasError) {
            return widget.builder(context, QueryError(snap.error));
          }
          if (snap.hasData) {
            return widget.builder(context, snap.data);
          }
          return widget.builder(context, QueryLoading());
        });
  }
}

/// Use this widget to attach a listener to a query result reacting to state changes
///
/// pass your query model as parameter
/// pass a listener function to handle state changes
class QueryListener<ResultType> extends StatefulWidget {
  final QueryModel<dynamic, ResultType> query;
  final Widget child;
  final void Function(BuildContext context, QueryState state) listener;

  const QueryListener({
    Key? key,
    required this.query,
    required this.child,
    required this.listener,
  }) : super(key: key);

  @override
  _QueryListenerState<ResultType> createState() =>
      _QueryListenerState<ResultType>();
}

class _QueryListenerState<ResultType> extends State<QueryListener<ResultType>> {
  StreamSubscription? _listenerSub;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _update();
  }

  @override
  void didUpdateWidget(covariant QueryListener<ResultType> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _update();
  }

  @override
  void dispose() {
    _listenerSub?.cancel();
    super.dispose();
  }

  void _update() {
    final fluq = Fluq.of(context);
    fluq.prefetch(widget.query);
    _listenerSub?.cancel();
    _listenerSub = fluq.getQueryStream(widget.query.key)!.listen((value) {
      widget.listener(context, value);
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
