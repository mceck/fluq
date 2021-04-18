import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:fluq/fluq/fluq_cache.dart';

mixin RapiSingleChild on SingleChildWidget {}

/// Wrap your application or th part of it where you want to use fluq with this single provider
class FluqProvider extends SingleChildStatefulWidget with RapiSingleChild {
  final Fluq cache = Fluq();

  FluqProvider({
    Key key,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  State<StatefulWidget> createState() => _FluqProviderState();
}

class _FluqProviderState extends SingleChildState<FluqProvider> {
  @override
  void dispose() {
    widget.cache.dispose();
    super.dispose();
  }

  @override
  Widget buildWithChild(BuildContext context, Widget child) {
    return InheritedProvider.value(
      value: widget.cache,
      child: child,
    );
  }
}
