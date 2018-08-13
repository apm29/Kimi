import 'package:flutter/material.dart';
import 'package:flutter_office/text_style.dart';
import 'package:flutter_office/ui/widget.dart';

class FormPage extends StatefulWidget {


  @override
  FormPageState createState() {
    return new FormPageState();
  }
}

class FormPageState extends State<FormPage> {
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      appBar: new GradientAppBar("个人信息"),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: new Icon(Icons.ac_unit), title: Text("SNOW")),
          BottomNavigationBarItem(
              icon: new Icon(Icons.audiotrack), title: Text("MUSIC"))
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: new ApplicationForm(),
    );
  }
}

class ApplicationForm extends StatefulWidget {

  final globalKey = new GlobalKey<FormState>(debugLabel: "form_application");

  @override
  State createState() => new ApplicationFormState(globalKey);
}

class ApplicationFormState extends State<ApplicationForm> {
  var controllerName = new TextEditingController();
  var controllerId = new TextEditingController();
  var controllerGender = new TextEditingController();

  var globalKey;

  ApplicationFormState(this.globalKey);

  @override
  Widget build(BuildContext context) {
    return new Form(
      key: globalKey,
      child: ListView(

        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 8.0),
            decoration: BoxDecoration(
              border:BorderDirectional(bottom: new BorderSide(
                color: Colors.black12
              )),
            ),
            child: Row(
              children: <Widget>[
                 Text.rich( TextSpan(children: [
                   TextSpan(text: "*",style: baseTextStyle.copyWith(color: Colors.pink)),
                   TextSpan(text: "姓名"),
                ]),),
                Container(width: 12.0,),
                Expanded(

                  child: TextFormField(
                    controller: controllerName,
                    decoration: InputDecoration.collapsed(hintText: "请输入姓名"),
                    // The validator receives the text the user has typed in
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 8.0),
            decoration: BoxDecoration(
              border:BorderDirectional(bottom: new BorderSide(
                  color: Colors.black12
              )),
            ),
            child: Row(
              children: <Widget>[
                Text.rich( TextSpan(children: [
                  TextSpan(text: "*",style: baseTextStyle.copyWith(color: Colors.pink)),
                  TextSpan(text: "身份证"),
                ]),),
                Container(width: 12.0,),
                Expanded(

                  child: TextFormField(
                    controller: controllerId,
                    decoration: InputDecoration.collapsed(hintText: "请输入身份证"),
                    // The validator receives the text the user has typed in
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          RaisedButton(
            onPressed: () {
              // Validate will return true if the form is valid, or false if
              // the form is invalid.
              if (globalKey.currentState.validate()) {
                // If the form is valid, we want to show a Snackbar
                Scaffold
                    .of(context)
                    .showSnackBar(SnackBar(content: Text('Processing Data')));
                globalKey.currentState.save();
                
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
