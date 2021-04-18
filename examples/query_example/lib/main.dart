import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:query_example/my_query.dart';
import 'package:fluq/fluq.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
  void _swapPage(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MySecondPage()));
  }

  Widget buildMyQuery(BuildContext context, QueryState state) {
    if (state is QueryLoading) {
      return CircularProgressIndicator();
    }
    if (state is QueryError) {
      return Text('${state?.error}');
    }
    final result = state as QueryResult;
    return Text(json.encode(result.data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Homepage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            QueryBuilder(
              query: MyQuery(),
              builder: buildMyQuery,
            ),
            QueryBuilder(
              query: MyQuery(),
              builder: buildMyQuery,
            ),
            QueryBuilder(
              query: MyQuery(),
              builder: buildMyQuery,
            ),
            QueryBuilder(
              query: MyQuery(),
              builder: buildMyQuery,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _swapPage(context),
        tooltip: 'swap page',
        child: Icon(Icons.next_plan_outlined),
      ),
    );
  }
}

class MySecondPage extends StatelessWidget {
  void _swapPage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  Widget buildMyQuery(BuildContext context, QueryState state) {
    if (state is QueryLoading) {
      return CircularProgressIndicator();
    }
    if (state is QueryError) {
      return Text('${state?.error}');
    }
    final result = state as QueryResult;
    return Text(json.encode(result.data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Second Page'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            QueryBuilder(
              query: MyQuery(),
              builder: buildMyQuery,
            ),
            QueryBuilder(
              query: MyQuery(),
              builder: buildMyQuery,
            ),
            QueryBuilder(
              query: MyQuery(),
              builder: buildMyQuery,
            ),
            QueryBuilder(
              query: MyQuery(),
              builder: buildMyQuery,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _swapPage(context),
        tooltip: 'swap page',
        child: Icon(Icons.next_plan_outlined),
      ),
    );
  }
}
