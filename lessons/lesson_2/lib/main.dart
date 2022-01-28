import 'package:flutter/material.dart';
import 'package:lesson_2/widget.dart';

void main() {
  runApp(const Example());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(body: Example()),
    );
  }
}
