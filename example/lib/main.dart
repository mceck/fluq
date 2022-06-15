import 'package:flutter/material.dart';
import 'package:fluq/fluq.dart';

void main() {
  runApp(MyApp());
}

/// query declaration
class NumberQuery extends QueryModel<int, int> {
  NumberQuery(int parameter) : super('number-query', parameter: parameter);

  @override
  Future<int> fetch() async {
    await Future.delayed(const Duration(seconds: 1));
    return parameter! + 1;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// initialize Fluq provider
    return FluqProvider(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int param = 0;

  void incrementParam() {
    setState(() {
      param++;
    });
  }

  void decrementParam() {
    setState(() {
      param--;
    });
  }

  Widget buildMyQuery(BuildContext context, QueryState? state) {
    if (state == null || state is QueryLoading) {
      return const CircularProgressIndicator();
    }
    if (state is QueryError) {
      return Text('${state.error}');
    }
    final result = state as QueryResult<int>;
    return Text('param+1 = ' + result.data.toString());
  }

  @override
  Widget build(BuildContext context) {
    /// query listener, listen for error to display in snackbar
    return QueryListener(
      query: NumberQuery(param),
      listener: (context, state) {
        if (state is QueryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Text('Error!!!')],
              ),
            ),
          );
        }
        if (state is QueryResult<int> && state.data > 10) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Text('Counter > 10 :)')],
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Homepage'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Fluq.of(context).invalidateAllQuery();
                },
                child: const Text('invalidate all cache'),
              ),
              TextButton(
                onPressed: () {
                  Fluq.of(context).invalidateQuery(NumberQuery(param).key);
                },
                child: const Text('invalidate this query'),
              ),
              Mutation(
                fetch: (fluq) {
                  fluq.setQueryState(NumberQuery(param).key, QueryLoading());
                  return Future.delayed(const Duration(seconds: 1))
                      .then((_) => 10);
                },
                update: (fluq, int result) {
                  fluq.setQueryState(
                    NumberQuery(param).key,
                    QueryResult(result),
                  );
                },
                builder: (context, fetch) => TextButton(
                  onPressed: fetch,
                  child: const Text('trigger mutation set10'),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Fluq.of(context).setQueryState(
                      NumberQuery(param).key, QueryError('this is an error!'));
                },
                child: const Text('trigger error'),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: decrementParam,
                    child: const Text('-'),
                  ),
                  Text('dynamic param $param'),
                  TextButton(
                    onPressed: incrementParam,
                    child: const Text('+'),
                  ),
                ],
              ),
              // query builders
              QueryBuilder(
                query: NumberQuery(param),
                builder: buildMyQuery,
              ),
              const SizedBox(height: 50),
              const Text('static param=8'),
              QueryBuilder(
                query: NumberQuery(8),
                builder: buildMyQuery,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
