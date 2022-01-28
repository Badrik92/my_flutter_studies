import 'package:flutter/material.dart';

class Example extends StatelessWidget {
  const Example({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color:  Colors.red,
        padding: const EdgeInsets.all(20.0),
          child: Container(
          width: 30,
          height: 30,
          color: Colors.blue,
        ),
      ),
    );
  }
}
