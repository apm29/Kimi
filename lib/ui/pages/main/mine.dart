import 'package:flutter/material.dart';

class MineFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MineState();
  }
}

class MineState extends State<MineFragment> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(child: new Text("mine")),
    );
  }
}
