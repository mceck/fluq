import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController qid;

  @override
  void initState() {
    qid = TextEditingController(text: '10');
    super.initState();
  }

  @override
  void dispose() {
    qid?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(labelText: 'query id'),
                  controller: qid,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Fluq.of(context).invalidateQuery(int.parse(qid.text));
                  },
                  child: Text('invalidate'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Fluq.of(context).invalidateAllQuery();
                  },
                  child: Text('invalidate all'),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10000,
              itemBuilder: (context, index) => QueryBuilder(
                query: QueryMix(index),
                builder: (context, res) {
                  if (res is QueryResult) {
                    return Text(res.data['value']);
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QueryMix extends QueryModel {
  final _key;

  QueryMix(this._key);

  get key => _key;

  @override
  Future fetch() async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'value': 'test data $key',
    };
  }
}
