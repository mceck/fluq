import 'package:flutter/material.dart';

import 'package:fluq/fluq.dart';

/// Widget for handling mutations
class Mutation<ResultType> extends StatefulWidget {
  final Future<ResultType> Function(Fluq cache) fetch;
  final void Function(ResultType result)? onSuccess;
  final void Function(dynamic err)? onError;
  final void Function(Fluq cache, ResultType result)? update;
  final Widget Function(BuildContext context, Future Function() fetch) builder;
  final bool autoFetch;

  const Mutation({
    Key? key,
    required this.fetch,
    required this.builder,
    this.update,
    this.onSuccess,
    this.onError,
    this.autoFetch = false,
  }) : super(key: key);

  @override
  _MutationState<ResultType> createState() => _MutationState<ResultType>();
}

class _MutationState<ResultType> extends State<Mutation<ResultType>> {
  @override
  void initState() {
    if (widget.autoFetch) _fetch(context);
    super.initState();
  }

  Future _fetch(BuildContext context) {
    final fluq = Fluq.of(context);
    return widget.fetch(fluq).then((result) {
      if (widget.onSuccess != null) {
        widget.onSuccess!(result);
      }
      if (widget.update != null) {
        widget.update!(fluq, result);
      }
    }).catchError((err) {
      if (widget.onError != null) {
        widget.onError!(err);
      }
    });
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, () => _fetch(context));
}
