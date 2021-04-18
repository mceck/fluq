# fluq

Simple state management api for Flutter based on streams

All queries latest results are cached in streams and the results are fetched only the first time they will be accessed, the results will not be refetched untill the respective query will be manually invalidated

### Usage

Wrap all your app, or the part of the app where you want to use fluq in a FluqProvider widget

```
import 'package:fluq/fluq.dart';

void main() {
  runApp(
    FluqProvider(
      child: MyApp(),
    ),
  );
}
```

Declare your queries extending QueryModel and setting up an unique query id and implementing the fetch method

```
import 'package:fluq/fluq.dart';

class MyQuery extends QueryModel {
  @override
  get key => "my-query";

  @override
  Future fetch() async {
    final result = await something();
    return result;
  }
}

```

Access the result reactively to state changes with QueryBuilder widget

```
// ...
    QueryBuilder(
      query: MyQuery(),
      builder: (context, state) {
        if (state is QueryLoading) {
          return CircularProgressIndicator();
        }
        if (state is QueryError) {
          return Text('${state.error}');
        }
        final result = state as QueryResult;
          return Text(json.encode(result.data));
      },
    ),
// ...
```

Or simply attach a listener to a query to handle events on state change with QueryListener widget

```
// ...
    QueryListener(
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
      child: // ...
    ),
// ...

```

You can interact with query states or handle mutation events by accessing Fluq instance with providers directly in your handlers

```
// ...
  final fluq = Fluq.of(context);

  // update state
  fluq.setQueryState(MyQuery().key, QueryError('this is an error!'));

  // invalidate state and redo fetch for single or all queries
  fluq.invalidateQuery(MyQuery().key);
  fluq.invalidateAllQuery();
// ...
```

Or using Mutation widget

```
// ...
  Mutation(
    fetch: () => callSomething(),
    update: (fluq, result) {
      fluq.setQueryState(MyQuery().key, QueryResult(result));
    },
    onError: (err) => print(err),
    builder: (context, fetch) => TextButton(
      onPressed: fetch,
      child: Text('trigger update'),
    ),
  ),
// ...
```
