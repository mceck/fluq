import 'package:flutter/material.dart';

import 'package:fluq/fluq.dart';

class Mutation<T> extends StatefulWidget {
  final Future<T> Function() fetch;
  final void Function(T result) onSuccess;
  final void Function(dynamic err) onError;
  final void Function(Fluq cache, T result) update;
  final Widget Function(BuildContext context, Future Function() fetch) builder;
  final bool autoFetch;

  const Mutation({
    Key key,
    this.fetch,
    this.builder,
    this.onSuccess,
    this.onError,
    this.update,
    this.autoFetch = false,
  }) : super(key: key);

  @override
  _MutationState<T> createState() => _MutationState<T>();
}

class _MutationState<T> extends State<Mutation<T>> {
  @override
  void initState() {
    if (widget.autoFetch) _fetch(context);
    super.initState();
  }

  Future _fetch(BuildContext context) {
    return widget.fetch().then((result) {
      if (widget.onSuccess != null) {
        widget.onSuccess(result);
      }
      if (widget.update != null) {
        widget.update(Fluq.of(context), result);
      }
    }).catchError((err) {
      if (widget.onError != null) {
        widget.onError(err);
      }
    });
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, () => _fetch(context));
}
