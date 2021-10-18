// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
//import 'package:flutter/cupertino.dart';
import 'models/item.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:share/share.dart'; //..

void main() => runApp(App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var items = <Item>[];
  HomePage() {
    items = [];

    // items.add(Item(title: "Banana", done: false));
    // items.add(Item(title: "Abacate", done: false));
    // items.add(Item(title: "Mamão", done: false));
    // items.add(Item(title: "Pera", done: false));
    // items.add(Item(title: "Abacaxi", done: false));
    // items.add(Item(title: "Limão", done: false));
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskCtrl = TextEditingController();

  void add() {
    if (newTaskCtrl.text.isEmpty) return;
    setState(() {
      widget.items.add(
        Item(title: newTaskCtrl.text, done: false),
      );
      newTaskCtrl.text = "";
    });
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
    });
  }

  Future load() async {}

  @override
  void initState() {
    Map appsFlyerOptions = {
      "afDevKey": "u3M6e65SGK6mcKNtTEuUy",
      "afAppId": "1590196996",
      "isDebug": true
    };

    AppsflyerSdk appsflyerSdk = AppsflyerSdk(appsFlyerOptions);

    super.initState();

    appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true);

    logEvent('af_content_view', {"af_price": "200", "af_content_id": "1"},
        appsflyerSdk);
  }

  Future<bool?> logEvent(
      String eventName, Map eventValues, AppsflyerSdk appsflyerSdk) async {
    bool? result = false;
    try {
      result = await appsflyerSdk.logEvent(eventName, eventValues);
    } on Exception catch (e) {}
    print("Result logEvent: ${result}");
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: newTaskCtrl,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          decoration: InputDecoration(
              labelText: "Nova Tarefa",
              labelStyle: TextStyle(
                color: Colors.white,
              )),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext ctxt, int index) {
          final item = widget.items[index];
          return Dismissible(
            child: CheckboxListTile(
              title: Text(item.title),
              value: item.done,
              onChanged: (value) {
                setState(() {
                  item.done = value!;
                });
              },
            ),
            key: Key(item.title),
            background: Container(
              color: Colors.red,
            ),
            onDismissed: (direction) {
              remove(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add_task),
        backgroundColor: Colors.red,
      ),
    );
    Share.share('teste');

    Share.shareFiles(['${directory.path}/image.jpg'], text: 'Great picture');
    Share.shareFiles(
        ['${directory.path}/image1.jpg', '${directory.path}/image2.jpg']);
  }
}
