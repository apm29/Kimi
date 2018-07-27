import 'package:flutter/material.dart';
import 'package:flutter_office/ui/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      body: new Center(child: new ListView(children: <Widget>[
        new JunButton((){
          SharedPreferences.getInstance().then((instance){
            instance.clear();
            Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context){

            }));
          });
        },"退出"),
      ],)),
    );
  }
}
