import 'package:crs_scheduler/screens/initdetails.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
void main()  {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRS Scheduler',
      theme: ThemeData(

        // is not restarted.
        primarySwatch: Colors.blue,

      ),
      home: const MyHomePage(title: 'CRS Scheduler'),

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return  const DetailParent();


  }
}


class MyAPITest extends StatefulWidget {
  const MyAPITest({super.key});

  @override
  State<MyAPITest> createState() => _MyAPITestState();
}

class _MyAPITestState extends State<MyAPITest> {
  List data=[];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<String> getData() async {
    var response = await http.get(
        Uri.parse("http://127.0.0.1:5000/api/courses?prgm=BS_CS"),
        //headers: {"Accept": "application/json"}
        );

    setState(() {
      data = json.decode(response.body);
    });

    return "Success!";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("JSON Response"),
      ),
      body: Text(data.toString()),
    );
  }
}

