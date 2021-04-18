import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluq/fluq/query_state.dart';
import 'package:fluq/fluq/query_model.dart';
import 'package:fluq/fluq/fluq_cache.dart';

class QueryBuilder extends StatefulWidget {
  final QueryModel query;
  final Widget Function(BuildContext context, QueryState state) builder;
  final Widget Function(BuildContext context, QueryState state) listener;

  const QueryBuilder({Key key, this.query, this.builder, this.listener})
      : super(key: key);

  @override
  _QueryBuilderState createState() => _QueryBuilderState();
}

class _QueryBuilderState extends State<QueryBuilder> {
  StreamSubscription _listenerSub;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final fluq = Fluq.of(context);
    fluq.prefetch(widget.query);
    if (widget.listener != null) {
      _listenerSub = fluq.getQueryStream(widget.query.key).listen((value) {
        widget.listener(context, value);
      });
    }
  }

  @override
  void dispose() {
    if (_listenerSub != null) _listenerSub.cancel();
    super.dispose();
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

class QueryListener extends StatefulWidget {
  final QueryModel query;
  final Widget child;
  final void Function(BuildContext context, QueryState state) listener;

  const QueryListener({Key key, this.query, this.child, this.listener})
      : super(key: key);

  @override
  _QueryListenerState createState() => _QueryListenerState();
}

class _QueryListenerState extends State<QueryListener> {
  StreamSubscription _listenerSub;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final fluq = Fluq.of(context);
    fluq.prefetch(widget.query);
    if (widget.listener != null) {
      _listenerSub = fluq.getQueryStream(widget.query.key).listen((value) {
        widget.listener(context, value);
      });
    }
  }

  @override
  void dispose() {
    if (_listenerSub != null) _listenerSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
