import 'package:flutter/material.dart';
import 'package:stock_app/ui/widget/widget.dart';
import 'dart:async';
import 'package:stock_app/models/items.dart';
import 'package:stock_app/database/dbconn.dart';
import 'package:stock_app/ui/itemslist.dart';

void main() async {
  await DbConn;
  MaterialApp(
    debugShowCheckedModeBanner: false,
  );
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transactions',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DbConn dbconn = DbConn();
  List<Items> itemsList;
  int totalCount = 0 ;

  @override
  Widget build(BuildContext context) {

    if(itemsList == null) {
      itemsList = List<Items>();
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: new Container(
        child: new Center(
            child: new FutureBuilder(
              future: loadList(),
              builder: (context, snapshot) {
                return itemsList.length > 0? new ItemsList(items: itemsList):
                new Center(child:
                new Text('No Data Found, Tap Plus(+) Button To Add!', style: Theme.of(context).textTheme.title));
              },
            )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddScreen(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        child:  new FutureBuilder(
          future: loadTotal(),
          builder: (context, snapshot)  {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Total: \$$totalCount', style: Theme.of(context).textTheme.title),
            );
          },
        ),
        color: Colors.cyanAccent,
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future loadList() {
    final Future futureDB = dbconn.initDB();
    return futureDB.then((db) {
      Future<List<Items>> futureItems = dbconn.items();
      futureItems.then((itemsList) {
        setState(() {
          this.itemsList = itemsList;
        });
      });
    });
  }

  Future loadTotal() {
    final Future futureDB = dbconn.initDB();
    return futureDB.then((db) {
      Future<int> futureTotal = dbconn.countTotal();
      futureTotal.then((ft) {
        setState(() {
          this.totalCount = ft;
        });
      });
    });
  }

  _navigateToAddScreen (BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddDataWidget()),
    );
  }
}