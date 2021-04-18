import 'dart:convert';

import 'package:cache_mutation_example/my_query.dart';
import 'package:flutter/material.dart';
import 'package:fluq/fluq.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // initialize Fluq provider
    return FluqProvider(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  Widget buildMyQuery(BuildContext context, QueryState state) {
    if (state is QueryLoading) {
      return CircularProgressIndicator();
    }
    if (state is QueryError) {
      return Text('${state.error}');
    }
    final result = state as QueryResult;
    return Text(json.encode(result.data));
  }

  @override
  Widget build(BuildContext context) {
    // query listener, listen for error to display in snackbar
    return QueryListener(
      query: MyQuery(),
      listener: (context, state) {
        if (state is QueryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(' Error!!!')],
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Homepage'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // test actions
              TextButton(
                onPressed: () {
                  Fluq.of(context).invalidateAllQuery();
                },
                child: Text('invalidate cache'),
              ),
              TextButton(
                onPressed: () async {
                  Fluq.mutate(context,
                      fetch: () => Future.delayed(const Duration(seconds: 1))
                          .then((_) => 'new result'),
                      update: (fluq, result) {
                        fluq.setQueryState(
                          MyQuery().key,
                          QueryResult({'result': result}),
                        );
                      });
                },
                child: Text('trigger mutation'),
              ),
              TextButton(
                onPressed: () async {
                  Fluq.of(context).setQueryState(
                      MyQuery().key, QueryError('this is an error!'));
                },
                child: Text('trigger error'),
              ),
              // query builders
              QueryBuilder(
                query: MyQuery(),
                builder: buildMyQuery,
              ),
              QueryBuilder(
                query: MyQuery(),
                builder: buildMyQuery,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
